//
//  Endpoint.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

private let dateFormatter = DateFormatter.create(format: "yyyy-MM-dd")
private let dateTimeFormatter = DateFormatter.create(format: "yyyy-MM-dd HH:mm:ss")

class Endpoint {
    static let baseUrl = URL(string: "https://api.appfollow.io")!
    static let keySign = "sign"
    static let keyCid = "cid"

    static func date(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    static func toDate(_ string: String) -> Date {
        if string.isEmpty {
            return Date.unknown
        }
        return dateTimeFormatter.date(from: string) ?? Date.unknown
    }
    
    static func sign(parameters: [String: Any], path: String, auth: Auth) -> String {
        let sortedKeys = parameters.keys.sorted()
        let paramersString = (sortedKeys.map { "\($0)=\(String(describing: parameters[$0]!))" } as [String]).joined(separator: "")
        return Hash.md5(input: "\(paramersString)\(path)\(auth.secret)").map { String(format: "%02hhx", $0) }.joined()
    }
}
