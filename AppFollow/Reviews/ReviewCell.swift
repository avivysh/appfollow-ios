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

class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var stars: CosmosView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var info: UILabel!
    
    override public func prepareForReuse() {
        // Ensures the reused cosmos view is as good as new
        stars.prepareForReuse()
    }
    
    func bind(review: Review, app: App) {
        
        self.author.text = review.author.isEmpty ? "Unknown" : review.author
        self.stars.rating = review.rating
        self.stars.settings.updateOnTouch = false
        self.stars.settings.starMargin = 2
        
        if (review.title.isEmpty) {
             self.content.text = review.content.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            let attributedString = NSMutableAttributedString(
                string:review.title,
                attributes:[.font : UIFont.boldSystemFont(ofSize: 12)]
            )
            attributedString.append(NSMutableAttributedString(string:" " + review.content))
            self.content.attributedText = attributedString
        }
        
        self.info.text = "   \(review.date) \(review.locale) \(review.version)\(review.answered ? "✅" : "")"
        if self.icon != nil {
            IconLoader.into(self.icon, url: app.details.icon)
        }
    }
}
