//
//  Endpoint.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

protocol EndpointRoute {
    var path: String { get }
    var parameters: [String: Any] { get }
}

class Endpoint {
    let baseUrl = URL(string: "https://api.appfollow.io")!
    
    func sign(route: EndpointRoute, auth: Auth) -> [String: Any] {
        var parameters = route.parameters
        parameters["cid"] = auth.cid
        parameters["s"] = "app"
        let signature = self.sign(parameters: parameters, path: route.path, auth: auth)
        parameters["sign"] = signature
        return parameters
    }
    
    private func sign(parameters: [String: Any], path: String, auth: Auth) -> String {
        let sortedKeys = parameters.keys.sorted()
        let paramersString = (sortedKeys.map { "\($0)=\(String(describing: parameters[$0]!))" } as [String]).joined(separator: "")
        return Hash(input: "\(paramersString)\(path)\(auth.secret)").md5.hex
    }
}
