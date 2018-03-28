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
}
