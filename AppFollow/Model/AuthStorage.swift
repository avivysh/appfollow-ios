//
//  AuthStorage.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

protocol AuthProvider {
    var actual: Auth { get }
}

struct AuthProviderEmpty: AuthProvider {
    let actual = Auth.empty
}

struct AuthProviderStorage: AuthProvider {
    let authStorage: AuthStorage
    var actual: Auth { return authStorage.retrieve() }
}

// TODO: Async?
protocol AuthStorage {
    func retrieve() -> Auth
    func persist(auth: Auth)
}

class UserDefaultAuthStorage: AuthStorage {
    private static let keyCid = "auth_cid"
    private static let keySecret = "auth_secret"
    
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    func retrieve() -> Auth {
        let cid = self.defaults.integer(forKey: UserDefaultAuthStorage.keyCid)
        if (cid == 0) {
            return Auth.empty
        }
        let secret = self.defaults.string(forKey: UserDefaultAuthStorage.keySecret) ?? ""
        return Auth(cid: cid, secret: secret)
    }
    
    func persist(auth: Auth) {
        if (auth.cid == 0) {
            self.defaults.removeObject(forKey: UserDefaultAuthStorage.keyCid)
            self.defaults.removeObject(forKey: UserDefaultAuthStorage.keySecret)
            return
        }
        self.defaults.set(auth.cid, forKey: UserDefaultAuthStorage.keyCid)
        self.defaults.set(auth.secret, forKey: UserDefaultAuthStorage.keySecret)
    }
    
}
