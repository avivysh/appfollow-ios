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
        if let mainNavigation = AppDelegate.provide.mainNavigation {
            if !payload.extId.isEmpty {
                let app = AppDelegate.provide.store.appFor(extId: payload.extId)
                if payload.reviewId.isEmpty {
                    // TODO: Fetch if not available
                    mainNavigation.navigateToApp(app: app)
                } else {
                    mainNavigation.navigateToReview(app: app, reviewId: payload.reviewId)
                }
            } else {
                mainNavigation.navigateToApps()
            }
            complete()
        }
    }
}
