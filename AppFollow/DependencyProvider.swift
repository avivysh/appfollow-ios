//
//  DependencyProvider.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

class DependencyProvider {
    
    let authStorage = UserDefaultAuthStorage(defaults: UserDefaults.standard)
    var auth: Auth {
        get { return self.authStorage.retrieve() }
    }
    let store = Store()
    lazy var stateRefresh = StateRefresh(store: self.store, auth: self.auth )
    let profileStorage = ProfileStorage(defaults: UserDefaults.standard)
    var profile: Profile {
        get { return self.profileStorage.retrieve() }
    }
}
