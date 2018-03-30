//
//  AppCell.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import AlamofireImage

private let placeholder = UIImage(named: "ic_photo_black_48px")!

class AppCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var publisher: UILabel!
    
    func bind(app: App) {
        self.title.text = app.details.title.isEmpty ? "Unknown" : app.details.title
        self.publisher.text = app.details.publisher.isEmpty ? "Unknown" : app.details.publisher
        
        if let url = URL(string: app.details.icon) {
            self.icon.af_setImage(
                withURL: url,
                placeholderImage: placeholder,
                filter: AspectScaledToFitSizeFilter(size: self.icon.frame.size)
            )
        } else {
            self.icon.image = placeholder
        }
    }
}
