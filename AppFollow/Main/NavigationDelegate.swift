//
//  NavigationDelegate.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 13/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

protocol NavigationDelegate {

    func navigateToApp(app: App)
    func navigateToReview(app: App, reviewId: ReviewId)
    func navigateToApps()

}
