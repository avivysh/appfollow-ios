//
//  Data.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 03/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

extension Data {
    var hex: String {
        get {
            return self.map { String(format: "%02hhx", $0) }.joined()
        }
    }
}
