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

class IconRemote {
    let url: String

    init(url: String) {
        self.url = url
    }

    func into(_ imageView: UIImageView) {
        if let url = URL(string: self.url) {
            imageView.af_setImage(
                withURL: url,
                placeholderImage: placeholder,
                filter: AspectScaledToFitSizeFilter(size: imageView.frame.size)
            )
        } else {
            imageView.image = placeholder
        }
    }
    
    func into(_ barButton: UIBarButtonItem) {
        if let url = URL(string: self.url) {
            ImageDownloader.default.download(
                URLRequest(url: url),
                filter: AspectScaledToFitSizeFilter(size: CGSize(width: 32, height: 32))) { response in
                if let image = response.result.value {
                    barButton.image = image.withRenderingMode(.alwaysOriginal)
                }
            }
        } else {
            barButton.image = placeholder
        }
    }
}
