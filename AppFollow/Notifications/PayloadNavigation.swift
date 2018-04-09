//
//  DeeplinkNavigation.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 05/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

class PayloadNavigation {
    let payload: Payload
    
    init(payload: Payload) {
        self.payload = payload
    }
    
    func perform(complete: () -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let mainViewController = appDelegate.window?.rootViewController as? MainViewController {
            if !payload.extId.isEmpty {
                let app = AppDelegate.provide.store.appFor(extId: payload.extId)
                // TODO: Fetch if not available
                mainViewController.navigateToApp(app: app)
            } else {
                mainViewController.navigateToApps()
            }
            complete()
        }
    }
}
