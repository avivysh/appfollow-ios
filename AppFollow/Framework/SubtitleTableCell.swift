//
//  SubtitleTableCell.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 02/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

class SubtitleTableCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    func bind(title: String, subtitle: String) {
        self.title.text = title
        self.subtitle.text = subtitle
    }
}
