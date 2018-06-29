//
//  ResetViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 16/06/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import ToastSwiftFramework
import Alamofire
import SwiftyBeaver

private let session: SessionManager = {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
    
    return SessionManager(configuration: configuration)
}()

class ResetViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func actionReset(_ sender: UIButton) {
        let email = self.username.text ?? ""
        
        if email.isEmpty || !email.contains("@") {
            self.view.makeToast("Email is not valid", duration: 3.0, position: .top)
            return
        }
        
        sender.isEnabled = false

        let route = ForgotRoute(email: email)
        ApiRequest(route: route, auth: AuthProviderEmpty()).get {
            (response: ForgotResponse?, error: Error?) in
            
            if let _ = response {
                self.view.makeToast("Instructions have been sent to \(email). Please check your email.", duration: 2.0, position: .top) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                sender.isEnabled = true
                self.view.makeToast(error?.localizedDescription ?? "Unknown erro", duration: 3.0, position: .top)
            }
        }
    }
}
