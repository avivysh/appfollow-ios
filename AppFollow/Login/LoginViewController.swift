//
//  ViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 27/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import WebKit
import TTGSnackbar

class LoginViewController: UIViewController, LoginProcessDelegate {

    static func instantiateFromStoryboard() -> LoginViewController {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        return controller
    }
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var webView: WKWebView!
    
    var loginProcess: LoginProcess?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginProcess = WebViewLoginProcess(webView: webView)
        self.loginProcess?.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    
    @IBAction func actionLogin(_ sender: Any) {
        let username = self.username.text ?? ""
        let password = self.password.text ?? ""

        self.loginProcess?.start(email: username, password: password)
    }
    
    // MARK: LoginProcessDelegate
    
    func loginError(message: String) {
        let snackbar = TTGSnackbar(message: message, duration: .short)
        snackbar.show()
    }

    func loginSuccess(auth: Auth, profile: Profile) {
        AppDelegate.provide.authStorage.persist(auth: auth)
        AppDelegate.provide.profileStorage.persist(profile: profile)
        
        let main = MainViewController.instantiateFromStoryboard()
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = main
    }

}

