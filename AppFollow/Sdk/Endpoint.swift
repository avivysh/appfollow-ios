//
//  Endpoint.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

class Endpoint {
    static let baseUrl = URL(string: "https://api.appfollow.io")!
    static let keySign = "sign"
    static let keyCid = "cid"

    static func sign(parameters: [String: Any], path: String, auth: Auth) -> String {
        let sortedKeys = parameters.keys.sorted()
        let paramersString = (sortedKeys.map { "\($0)=\(String(describing: parameters[$0]!))" } as [String]).joined(separator: "")
        return Hash.md5(input: "\(paramersString)\(path)\(auth.secret)").map { String(format: "%02hhx", $0) }.joined()
    }
}
