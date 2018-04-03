//
//  AnswerCell.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 02/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

class AnswerCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    
    func bind(answer: ReviewAnswer) {
        self.title.text = "Answered on \(answer.date)"
        self.content.text = answer.text
    }
}
