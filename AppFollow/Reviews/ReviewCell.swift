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

protocol ShareDelegate: NSObjectProtocol {
    func share(text: String)
}

class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var stars: CosmosView!
    @IBOutlet weak var content: UILabel!
    
    weak var shareDelegate: ShareDelegate? = nil
    
    private var authorName = ""
    private var appTitle = ""
    
    override public func prepareForReuse() {
        // Ensures the reused cosmos view is as good as new
        stars.prepareForReuse()
    }
    
    func bind(review: Review, app: App) {
        self.appTitle = app.details.title
        self.authorName = review.author.isEmpty ? "User" : review.author
        var info = "・\(review.date.ymd)"
        if (!review.locale.isEmpty) {
            info += "・\(review.locale)"
        }
        if (!review.version.isEmpty) {
            info += "・\(review.version)"
        }
        var store = ""
        if (!app.store.isEmpty) {
            store = app.charForStore.rawValue
            info += "・"
        }
        
        let answered = self.authorName + (review.answered ? "✅" : "")
        let title = answered + info + store
        
        let titleAttr = NSMutableAttributedString(string: title)
        let attrs: [NSAttributedString.Key:Any] = [
            .font: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .thin),
            .foregroundColor: UIColor.gray]
        let range = title.range(of: info)!
        titleAttr.addAttributes(attrs, range: NSRange(range, in: title))
        
        if (!store.isEmpty) {
            let attrs: [NSAttributedString.Key:Any] = [
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
    
    // Private
    
    @objc func shareFeedback(_ sender: UIMenuItem) {
        self.shareDelegate?.share(text: textForSharing())
    }
    
    @objc func copyFeedback(_ sender: UIMenuItem) {
        UIPasteboard.general.string = textForSharing()
    }
    
    private func textForSharing() -> String {
        let rating = Int(self.stars.rating)
        var stars = ""
        for i in 0..<5 {
            if (i <= rating) {
                stars += "⭑"//✩
            } else {
                stars += "✩"
            }
        }
        let content = self.content.attributedText?.string ?? self.content.text ?? ""
        return "\(stars) by \(self.authorName) - \(content) for \(self.appTitle)"
    }
}
