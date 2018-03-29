//
//  ExtIdDecoder.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

struct ExtId : Codable, Hashable {
    
    static func ==(lhs: ExtId, rhs: ExtId) -> Bool {
        return lhs.value == rhs.value
    }
    
    let value: String
    
    init(value: String) {
        self.value = value
    }
    
    var isEmpty: Bool {
        get { return self.value.isEmpty }
    }
    
    var hashValue: Int {
        return self.value.hashValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        var extId = ""
        if let value = try? container.decode(String.self) {
            extId = value
        } else if let value = try? container.decode(Int.self) {
            extId = String(value)
        }
        self.value=extId
    }
}

