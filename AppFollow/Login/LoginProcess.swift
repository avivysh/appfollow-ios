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
