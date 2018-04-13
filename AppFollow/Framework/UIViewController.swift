//
//  UIViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 13/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    func present(url: URL) {
        let safari = SFSafariViewController(url: url)
        safari.dismissButtonStyle = .close
        safari.preferredBarTintColor = UIColor.black
        self.present(safari, animated: true, completion: nil)
    }
}
