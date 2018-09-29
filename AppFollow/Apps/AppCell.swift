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
        
        let store = app.charForStore.rawValue
        let title = (store.isEmpty) ? "\(app.nameForStore)" : "\(store) \(app.nameForStore)"
        let titleAttr = NSMutableAttributedString(string: title)

        if (!store.isEmpty) {
            let attrs: [NSAttributedString.Key:Any] = [
                .font: UIFont(name: "FontAwesome5BrandsRegular", size: UIFont.smallSystemFontSize)!,
                .foregroundColor: UIColor.gray]
            let range = title.range(of: store)!
            titleAttr.addAttributes(attrs, range: NSRange(range, in: title))
        }
        
        self.store.attributedText = titleAttr
        
        IconRemote(url: app.details.icon).into(self.icon)
    }
}
