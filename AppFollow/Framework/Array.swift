//
//  Array.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 09/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

extension Array {
    func random() -> Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}
