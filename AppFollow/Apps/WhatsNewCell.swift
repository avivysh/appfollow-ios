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
        let date = "・\(whatsnew.releaseDate)"
        let title = "\(whatsnew.version) \(date)"
        let titleAttr = NSMutableAttributedString(string: title)
        let attrs: [NSAttributedStringKey:Any] = [
            .font: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .thin),
            .foregroundColor: UIColor.gray]
        let range = title.range(of: date)!
        titleAttr.addAttributes(attrs, range: NSRange(range, in: title))
        self.title.attributedText = titleAttr
        self.subtitle.text = whatsnew.whatsnew
    }
}
