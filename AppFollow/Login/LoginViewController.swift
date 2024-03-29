//
//  ViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 27/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import ToastSwiftFramework
import Intercom

class LoginViewController: UIViewController, LoginProcessDelegate {

    static func instantiateFromStoryboard() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController") as! UINavigationController
        return controller
    }
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var loginProcess: LoginProcess?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.loginProcess = PostLoginProcess()
        self.loginProcess?.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        let username = self.username.text ?? ""
        let password = self.password.text ?? ""

        self.loginProcess?.start(email: username, password: password)
    }
    
    @IBAction func actionSignup(_ sender: UIButton) {
        self.present(url: URL(string: "https://appfollow.io")!)
    }
    
    @IBAction func actionLiveDemo(_ sender: UIButton) {
        let config = AppDelegate.provide.configuration
        self.username.text = config.demoUser
        self.password.text = config.demoPassword
        
        let username = self.username.text ?? ""
        let password = self.password.text ?? ""
        
        self.loginProcess?.start(email: username, password: password)
    }
    
    // MARK: LoginProcessDelegate
    
    func loginError(message: String) {
        self.view.makeToast(message, duration: 3.0, position: .top)
    }
    
    func loginProgress(message: String) {
        self.view.makeToast(message, duration: 5.0, position: .top)
    }

    func loginSuccess(auth: Auth, profile: Profile) {
        AppDelegate.provide.authStorage.persist(auth: auth)
        AppDelegate.provide.profileStorage.persist(profile: profile)
        
        Intercom.registerUser(withUserId: "\(auth.cid)")
        let main = MainViewController.instantiateFromStoryboard()
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = main
    }
}

