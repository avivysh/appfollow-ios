//
//  DeeplinkNavigation.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 05/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

class DeeplinkNavigation {
    let deeplink: Deeplink
    
    init(deeplink: Deeplink) {
        self.deeplink = deeplink
    }
    
    func perform(complete: () -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let mainViewController = appDelegate.window?.rootViewController as? MainViewController {
            if !deeplink.appId.isEmpty {
                let app = AppDelegate.provide.store.appFor(appId: deeplink.appId)
                // TODO: Fetch if not available
                mainViewController.navigateToApp(app: app)
            } else if !deeplink.collection.isEmpty {
                mainViewController.navigateToApps()
            }
            complete()
        }
        
    }
}
