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

struct Profile: Decodable {
    let email: String
    let name: String
    let image: String
    let description: String
    let company: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case image
        case description
        case company
    }
    
    init(email: String, name: String, image: String, description: String, company: String) {
        self.email = email
        self.name = name
        self.image = image
        self.description = description
        self.company = company
    }
    
    init(email: String, profile: Profile) {
        self.email = email
        self.name = profile.name
        self.image = profile.image
        self.description = profile.description
        self.company = profile.company
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        self.email = ""
        self.name =  try map.decodeIfPresent(.name) ?? ""
        self.image = try map.decodeIfPresent(.image) ?? ""
        self.description = try map.decodeIfPresent(.description) ?? ""
        self.company = try map.decodeIfPresent(.company) ?? ""
    }
}

struct LoginResponse: Decodable {
    let cid: Int
    let secret: String
    let profile: Profile
    
    var auth: Auth {
        return Auth(cid: cid, secret: secret)
    }
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
