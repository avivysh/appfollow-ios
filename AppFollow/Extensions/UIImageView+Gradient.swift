//
//  UIImageView+Gradient.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 09/06/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

extension UIImageView {
    func addGradientLayer(colors: [UIColor]){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map{$0.cgColor}
        gradientLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        self.layer.addSublayer(gradientLayer)
    }
}
