//
//  Auth.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

struct Auth: Decodable {
    static let empty = Auth(cid: 0, secret: "")

    let cid: Int
    let secret: String
}

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct ProfileRoute: EndpointRouteBody {
    let path = "/profile"
    let parameters: [String: Any] = [:]
    let body: LoginRequest
}
