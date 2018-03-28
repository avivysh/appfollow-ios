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
    func loginSuccess(auth: Auth)
}

protocol LoginProcess {
    var delegate: LoginProcessDelegate? { get set }
    func start(userName: String, password: String)
}

class WebViewLoginProcess: NSObject, WKNavigationDelegate, LoginProcess {
    
    private weak var webView: WKWebView?
    private var submitted = false

    init(webView: WKWebView) {
        self.webView = webView
        super.init()
        
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: "https://watch.appfollow.io/login")!))
    }
    
    var delegate: LoginProcessDelegate?
    
    func start(userName: String, password: String) {
        
        let js = """
        $('#login-email').val('\(userName.escapeJavaScript())');
        $('#login-password').val('\(password.escapeJavaScript())');
        """
        
        self.webView?.evaluateJavaScript(js) {
            result, error in
            self.submitted = true
            self.webView?.evaluateJavaScript("$('button.js-login-submit').click();", completionHandler: nil)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if (webView.url?.path == "/login" && self.submitted) {
            self.checkForErrors()
            return
        }
        
        if (webView.url?.path == "/apps/myapps") {
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
            guard let message = result as? String else { return }
            self.delegate?.loginError(message: message)
        }
    }
    
    private func readAuth() {
        let js = """
        $('div.content_box > div').find('strong:contains(cid)').parent().text().trim().split(/\\s/).filter(function(v) { return !!v })
        """
        self.webView?.evaluateJavaScript(js) {
            result, error in
            guard let list = result as? [Any],
                  let cidStr = list[1] as? String,
                  let cid = Int(cidStr),
                  let secret = list[3] as? String
                 else {
                    self.webView?.load(URLRequest(url: URL(string: "https://watch.appfollow.io/login")!))
                    self.delegate?.loginError(message: "Cennot fetch api secret")
                    return
            }
            
            self.delegate?.loginSuccess(auth: Auth(cid: cid, secret: secret))
        }
    }
}
