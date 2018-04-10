//
//  MainViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

private enum Tab: Int {
    case Reviews = 0
    case Apps
    case Profile
}

class MainViewController: UITabBarController {
    static func instantiateFromStoryboard() -> MainViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! MainViewController
        return controller
    }
    
    func navigateToApp(app: App) {
        self.selectedIndex = Tab.Apps.rawValue
        if let tabViewContainer = self.selectedViewController as? TabViewController {
            let appViewController = AppViewController.instantiateFromStoryboard(app: app)
            tabViewContainer.embedController?.pushViewController(appViewController, animated: true)
        }
    }
    
    func navigateToReview(app: App, reviewId: ReviewId) {
        self.selectedIndex = Tab.Apps.rawValue
        if let tabViewContainer = self.selectedViewController as? TabViewController {
            let appViewController = AppViewController.instantiateFromStoryboard(app: app)
            let reviewViewController = ReviewViewController.instantiateFromStoryboard(app: app, reviewId: reviewId)
            tabViewContainer.embedController?.setViewControllers([appViewController, reviewViewController], animated: true)
        }
    }
    
    func navigateToApps() {
        self.selectedIndex = Tab.Apps.rawValue
        if let tabViewContainer = self.selectedViewController as? TabViewController {
            tabViewContainer.embedController?.popToRootViewController(animated: true)
        }
    }
}
