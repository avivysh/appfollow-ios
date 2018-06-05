//
//  Configuration.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 05/06/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

struct Configuration: Decodable {
    var intercomAppId: String
    var intercomApiKey: String

    static func load() -> Configuration {
        let path = Bundle.main.path(forResource: "Configuration", ofType: "plist")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = PropertyListDecoder()
        return try! decoder.decode(Configuration.self, from: data)
    }
}
