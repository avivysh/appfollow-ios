//
//  AppCell.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

class AppCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var store: UILabel!
    
    func bind(app: App) {
        self.title.text = app.details.title.isEmpty ? "Unknown" : app.details.title
        self.publisher.text = app.details.publisher.isEmpty ? "Unknown" : app.details.publisher
        self.store.text = self.storeName(kind: app.store)
        IconRemote(url: app.details.icon).into(self.icon)
    }
    
    func storeName(kind: String) -> String {
        switch kind {
        case "googleplay": return "Google Play"
        case "itunes": return "App Store"
        case "microsoftstore": return "Windows Store"
        case "amazon": return "Amazon"
        case "macstore": return "Mac App Store"
        default:
            return kind.localizedUppercase
        }
    }
}
