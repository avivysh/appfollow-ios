//
//  ReviewCell.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import Cosmos
import AlamofireImage

private let placeholder = UIImage(named: "ic_image_black_48px")!

class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var stars: CosmosView!
    @IBOutlet weak var content: UILabel!
    
    func bind(review: Review, app: App) {
        
        self.author.text = review.author
        self.stars.rating = review.rating
        self.content.text = review.content
        
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
