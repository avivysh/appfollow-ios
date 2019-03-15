//
//  UITableViewCell+Selection.swift
//  AppFollow
//
//  Created by Alexander Gavrishev on 15/03/2019.
//  Copyright © 2019 Anodsplace. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    public var selectedBackroundColor: UIColor {
        get {
            return self.selectedBackgroundView?.backgroundColor ?? UIColor()
        }
        
        set(color) {
            let cellBGView = UIView()
            cellBGView.backgroundColor = color
            self.selectedBackgroundView = cellBGView
        }
    }
}
