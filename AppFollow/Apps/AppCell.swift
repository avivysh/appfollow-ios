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
    
    func bind(app: App) {
        self.title.text = app.details.title.isEmpty ? "Unknown" : app.details.title
        self.publisher.text = app.details.publisher.isEmpty ? "Unknown" : app.details.publisher
        IconLoader.into(self.icon, url: app.details.icon)
    }
}
