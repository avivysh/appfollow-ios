//
//  MainViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    static func instantiateFromStoryboard() -> MainViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! MainViewController
        return controller
    }
    
    func navigateToApp(app: App) {
        self.selectedIndex = 1
        if let tabViewContainer = self.selectedViewController as? TabViewController {
            let appViewController = AppViewController.instantiateFromStoryboard(app: app)
            tabViewContainer.embedController?.navigationController?.pushViewController(appViewController, animated: true)
        }
    }
    
    func navigateToApps() {
        self.selectedIndex = 1
        if let tabViewContainer = self.selectedViewController as? TabViewController {
            tabViewContainer.embedController?.navigationController?.popToRootViewController(animated: true)
        }
    }
}
