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
    
    func bind(review: Review, app: App) {
        
        self.author.text = review.author
        self.stars.rating = review.rating

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
        
        self.info.text = "   \(review.date) \(review.locale) \(review.appVersion)\(review.isAnswer == 1 ? "✅" : "")"
        IconLoader.into(self.icon, url: app.details.icon)
    }
}
