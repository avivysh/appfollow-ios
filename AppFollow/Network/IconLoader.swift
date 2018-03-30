//
//  IconLoader.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 30/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import AlamofireImage

private let placeholder = UIImage(named: "ic_photo_black_48px")!

class IconLoader {
    
    static func into(_ imageView: UIImageView, url: String) {
        if let url = URL(string: url) {
            imageView.af_setImage(
                withURL: url,
                placeholderImage: placeholder,
                filter: AspectScaledToFitSizeFilter(size: imageView.frame.size)
            )
        } else {
            imageView.image = placeholder
        }
    }
}
