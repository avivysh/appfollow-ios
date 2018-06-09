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

enum FontAwesome: String {
    case none = ""
    case android = "\u{f17b}"
    case mac = "\u{f170}"
    case windows = "\u{f17a}"
    case apple = "\u{f179}"
    case amazon = "\u{f270}"
}

class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var stars: CosmosView!
    @IBOutlet weak var content: UILabel!
    
    override public func prepareForReuse() {
        // Ensures the reused cosmos view is as good as new
        stars.prepareForReuse()
    }
    
    func bind(review: Review, app: App) {
        
        let author = review.author.isEmpty ? "User" : review.author
        var info = "・\(review.date.ymd)"
        if (!review.locale.isEmpty) {
            info += "・\(review.locale)"
        }
        if (!review.version.isEmpty) {
            info += "・\(review.version)"
        }
        var store = ""
        if (!app.store.isEmpty) {
            store = self.charForStore(app.store).rawValue
            info += "・"
        }
        
        let answered = author + (review.answered ? "✅" : "")
        let title = answered + info + store
        
        let titleAttr = NSMutableAttributedString(string: title)
        let attrs: [NSAttributedStringKey:Any] = [
            .font: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .thin),
            .foregroundColor: UIColor.gray]
        let range = title.range(of: info)!
        titleAttr.addAttributes(attrs, range: NSRange(range, in: title))
        
        if (!store.isEmpty) {
            let attrs: [NSAttributedStringKey:Any] = [
                .font: UIFont(name: "FontAwesome5BrandsRegular", size: UIFont.smallSystemFontSize)!,
                .foregroundColor: UIColor.gray]
            let range = title.range(of: store)!
            titleAttr.addAttributes(attrs, range: NSRange(range, in: title))
        }
        
        self.author.attributedText = titleAttr
        self.stars.rating = review.rating.value
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
        
        if self.icon != nil {
            IconRemote(url: app.details.icon).into(self.icon)
        }
    }
    
    func charForStore(_ store: String) -> FontAwesome {
        switch store {
            case "googleplay": return .android
            case "itunes": return .apple
            case "microsoftstore": return .windows
            case "amazon": return .amazon
            case "macstore": return .mac
            default:
                return .none
        }
    }
}
