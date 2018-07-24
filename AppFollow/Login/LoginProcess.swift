//
//  LoginProcess.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

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
            (loginResponse: LoginResponse?, error: Error?) in
                if let response = loginResponse {
                    let auth = Auth(cid: response.cid, secret: response.secret, email: email, hmac: response.hmac)
                    self.delegate?.loginSuccess(auth: auth, profile: response.profile)
                } else {
                    self.delegate?.loginError(message: "Unrecognized email/password")
                }
            }
        }
}
