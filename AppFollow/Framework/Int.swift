//
//  Int.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 09/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

extension Int {
    func random(from lowerBound: Int) -> Int {
        return lowerBound + Int(arc4random_uniform(UInt32(self - lowerBound)))
    }
}
