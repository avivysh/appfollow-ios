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

class AppsEndpoint {
    
    static let path = "/apps"
    static let url = URL(string: AppsEndpoint.path, relativeTo: Endpoint.baseUrl)!
    
    static func parameters(auth: Auth) -> [String: Any] {
        var parameters: [String: Any] = [ Endpoint.keyCid : auth.cid ]
        let signature = Endpoint.sign(parameters: parameters, path: AppsEndpoint.path, auth: auth)
        parameters[Endpoint.keySign] = signature
        return parameters
    }
}

class AppEndpoint {
    static let path = "/apps/app"
    static let url = URL(string: AppEndpoint.path, relativeTo: Endpoint.baseUrl)!

    static func parameters(collectionId: Int, auth: Auth) -> [String: Any] {
        var parameters: [String: Any] = [
            "apps_id" : collectionId,
            Endpoint.keyCid : auth.cid
        ]
        let signature = Endpoint.sign(parameters: parameters, path: AppEndpoint.path, auth: auth)
        parameters[Endpoint.keySign] = signature
        return parameters
    }
}

