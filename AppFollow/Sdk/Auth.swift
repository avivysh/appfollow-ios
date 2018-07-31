//
//  Auth.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

struct Auth: Decodable {
    static let empty = Auth(cid: 0, secret: "", email: "", hmac: "")

    let cid: Int
    let secret: String
    let email: String
    let hmac: String
}

struct Profile: Decodable {
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
    
    init(name: String, image: String, description: String, company: String) {
        self.name = name
        self.image = image
        self.description = description
        self.company = company
    }
    
    init(profile: Profile) {
        self.name = profile.name
        self.image = profile.image
        self.description = profile.description
        self.company = profile.company
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        self.name =  try map.decodeIfPresent(.name) ?? ""
        self.image = try map.decodeIfPresent(.image) ?? ""
        self.description = try map.decodeIfPresent(.description) ?? ""
        self.company = try map.decodeIfPresent(.company) ?? ""
    }
}

struct LoginResponse: Decodable {
    let cid: Int
    let secret: String
    let hmac: String
    let profile: Profile
    
    enum CodingKeys: String, CodingKey {
        case cid
        case secret
        case hmac
        case profile
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        self.cid =  try map.decode(.cid)
        self.secret = try map.decode(.secret)
        self.hmac = try map.decodeIfPresent(.hmac) ?? ""
        self.profile = try map.decode(.profile)
    }
}

struct LoginRequest: Encodable {
    let email: String
    let password: String
    let s = "app"
    let app = "ios"
}

struct ProfileRoute: EndpointRouteBody {
    let path = "/profile"
    let parameters: [String: Any] = [:]
    let body: LoginRequest
}

struct ForgotRequest: Encodable {
    let email: String
}

struct ForgotResponse: Decodable {
    let ok: Int
}

struct ForgotRoute: EndpointRoute {
    let email: String
    let path = "/forgot"
    var parameters: [String: Any] { get {
        return [
            "email" : email
        ]
    }}
}
