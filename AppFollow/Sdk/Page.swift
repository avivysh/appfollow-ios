//
//  Page.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 01/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

struct Page: Codable {
    let next: Int?
    let current: Int
    let prev: Int?
    let total: Int
}
