//
//  DependencyProvider.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

class DependencyProvider {
    
    let authStorage = UserDefaultAuthStorage(defaults: UserDefaults.standard)
    lazy var auth: AuthProvider = AuthProviderStorage(authStorage: authStorage)

    let store = Store()
    lazy var stateRefresh = StateRefresh(store: self.store, auth: self.auth )
    
    let profileStorage = ProfileStorage(defaults: UserDefaults.standard)
    var profile: Profile { return self.profileStorage.retrieve() }
    
    lazy var push = PushNotifications(auth: self.auth)    
    var notificationsDelegate = NotificationsDelegate()
    
    var mainNavigation: NavigationDelegate? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.window?.rootViewController as? NavigationDelegate
    }
}
