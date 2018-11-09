//
//  DeeplinkNavigation.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 05/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import Snail

class PayloadNavigation {
    private let unique = Unique(false)
    
    func perform(payload: Payload, complete: @escaping () -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.makeKeyAndVisible()
        
        if let mainNavigation = AppDelegate.provide.mainNavigation {
            if !payload.extId.isEmpty {
                self.fetchApp(extId: payload.extId) { app in
                    if payload.reviewId.isEmpty {
                        mainNavigation.navigateToApp(app: app)
                    } else {
                        mainNavigation.navigateToReview(app: app, reviewId: payload.reviewId)
                    }
                    complete();
                }
            } else {
                mainNavigation.navigateToReviews()
                complete()
            }
        }
    }
    
    func fetchApp(extId: ExtId, completion: @escaping (App) -> Void) {
        let allApps = AppDelegate.provide.store.appsFor(extId: extId)
        let app = allApps
            .first(where: { $0.hasReplyIntegration.value })
            ?? allApps.first
            ?? App.empty
        log.info("Fetching app \(extId.value)")
        if app.isEmpty {
            log.info("Waiting for refresh to finish")
            AppDelegate.provide.store.refreshed.subscribe(
                onNext: { _ in
                    log.info("Refreshed")
                    self.unique.value = true
                }
            )
            self.unique.asObservable().subscribe(
                onNext: { value in
                    if (!value) {
                        return
                    }
                    log.info("Completed")
                    let allApps = AppDelegate.provide.store.appsFor(extId: extId)
                    let app = allApps
                        .first(where: { $0.hasReplyIntegration.value })
                        ?? allApps.first
                        ?? App.empty
                    DispatchQueue.main.async {
                        completion(app)
                    }
                }
            )
        } else {
            log.info("Available locally. Completed.")
            completion(app)
        }
    }
}
