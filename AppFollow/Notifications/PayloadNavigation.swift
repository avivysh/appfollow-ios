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
    let payload: Payload
    
    let unique = Unique(false)

    init(payload: Payload) {
        self.payload = payload
    }
    
    func perform(complete: @escaping () -> Void) {
        if let mainNavigation = AppDelegate.provide.mainNavigation {
            if !payload.extId.isEmpty {
                self.fetchApp(extId: payload.extId) { app in
                    if self.payload.reviewId.isEmpty {
                        mainNavigation.navigateToApp(app: app)
                    } else {
                        mainNavigation.navigateToReview(app: app, reviewId: self.payload.reviewId)
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
        let app = AppDelegate.provide.store.appFor(extId: payload.extId)
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
                onNext: { _ in
                    log.info("Completed")
                    let app = AppDelegate.provide.store.appFor(extId: extId)
                    completion(app)
                }
            )
        } else {
            log.info("Available locally. Completed.")
            completion(app)
        }
    }
    
    private func navigateToApp(app: App, reviewId: ReviewId, mainNavigation: NavigationDelegate?) {
        if payload.reviewId.isEmpty {
            mainNavigation?.navigateToApp(app: app)
        } else {
            mainNavigation?.navigateToReview(app: app, reviewId: payload.reviewId)
        }
    }
}
