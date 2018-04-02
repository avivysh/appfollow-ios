//
//  WhatsNewCell.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 02/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

import UIKit

class WhatsNewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    func bind(whatsnew: WhatsNew) {
        self.title.text = "\(whatsnew.version) \(whatsnew.releaseDate)"
        self.subtitle.text = whatsnew.whatsnew
    }
}
