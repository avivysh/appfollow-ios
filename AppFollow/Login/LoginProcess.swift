//
//  LoginProcess.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation
import WebKit

protocol LoginProcessDelegate {
    func loginError(message: String)
    func loginProgress(message: String)
    func loginSuccess(auth: Auth, profile: Profile)
}

protocol LoginProcess {
    var delegate: LoginProcessDelegate? { get set }
    func start(email: String, password: String)
}

class PostLoginProcess: LoginProcess {
    var delegate: LoginProcessDelegate?
    
    func start(email: String, password: String) {
        let route: ProfileRoute = ProfileRoute(body: LoginRequest(email: email, password: password))
        self.delegate?.loginProgress(message: "Authorizing")
        ApiRequest(route: route, auth: AuthProviderEmpty()).post(body: route.body) {
            (auth: Auth?, error: Error?) in
                if let auth = auth {
                    self.delegate?.loginSuccess(auth: auth, profile: Profile(email: email, name: "", image: "/assets/img/avatar/steve.jpg", description: "", company: ""))
                } else {
                    self.delegate?.loginError(message: "Unrecognized email/password")
                }
            }
        }
}

class WebViewLoginProcess: NSObject, WKNavigationDelegate, LoginProcess {
    
    private weak var webView: WKWebView?
    private var submitted = false
    private var email = ""
    
    init(webView: WKWebView) {
        self.webView = webView
        super.init()
        
        webView.configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: "https://watch.appfollow.io/logout")!))
    }
    
    var delegate: LoginProcessDelegate?
    
    func start(email: String, password: String) {
        
        let js = """
        (function() {
        $('#login-email').val('\(email.safeJavaScript)');
        $('#login-password').val('\(password.safeJavaScript)');
        $('button.js-login-submit').removeAttr('disabled');
        $('button.js-login-submit').click();
        return "ok";
        })()
        """
        self.email = email
        self.submitted = true
        self.webView?.evaluateJavaScript(js) {
            result, error in
            log.info("[Login] start: \(result ?? ""), \(error?.localizedDescription ?? "")")
            self.delegate?.loginProgress(message: "Authorizing")
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        log.info("[Login] Finish navigation to \(webView.url?.path ?? "")")
        if (webView.url?.path == "/logout" && !self.submitted) {
            webView.load(URLRequest(url: URL(string: "https://watch.appfollow.io/login")!))
            return
        }
        if (webView.url?.path == "/login" && self.submitted) {
            self.checkForErrors()
            return
        }
        
        if (webView.url?.path.hasPrefix("/apps") == true) {
            let settingsUrl = URL(string: "/settings/general", relativeTo: webView.url)!
            webView.load(URLRequest(url: settingsUrl))
            return
        }
        
        if (webView.url?.path == "/settings/general") {
            self.readAuth()
        }
    }
    
    private func checkForErrors() {
        self.webView?.evaluateJavaScript("$('div.login-wrapper__msg--error').text()") {
            result, error in
            log.info("[Login] checkForErrors: \(result ?? ""), \(error?.localizedDescription ?? "")")
            guard let message = result as? String else { return }
            self.delegate?.loginError(message: message)
        }
    }
    
    private func readAuth() {
        let js = """
        (function() {
        var access = $('div.content_box > div').find('strong:contains(cid)').parent().text().trim().split(/\\s/).filter(function(v) { return !!v })
        var image = $('div.card img').attr('src')
        var description = $('div.card > .content > .description > strong').text()
        var name = $('input[name=name]').val()
        var company = $('input[name=company]').val()
        return { cid: parseInt(access[1],10), secret: access[3], image: image, description: description, name: name, company: company }
        })()
        """
        self.webView?.evaluateJavaScript(js) {
            result, error in
            log.info("[Login] readAuth: \(result ?? ""), \(error?.localizedDescription ?? "")")
            guard let list = result as? [String:Any],
                let cid = list["cid"] as? Int,
                let secret = list["secret"] as? String,
                let image = list["image"] as? String,
                let description = list["description"] as? String,
                let name = list["name"] as? String,
                let company = list["company"] as? String
            else {
                self.webView?.load(URLRequest(url: URL(string: "https://watch.appfollow.io/login")!))
                self.delegate?.loginError(message: "Cannot fetch api secret")
                return
            }
            
            self.webView?.load(URLRequest(url: URL(string: "https://watch.appfollow.io/logout")!))
            self.delegate?.loginSuccess(auth: Auth(cid: cid, secret: secret), profile: Profile(email: self.email, name: name, image: image, description: description, company: company))
        }
    }
}
