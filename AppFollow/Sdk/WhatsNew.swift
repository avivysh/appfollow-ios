//
//  WhatsNew.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 02/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

class WhatsNewEndpoint {
    static let path = "/whatsnew"
    static let url = URL(string: WhatsNewEndpoint.path, relativeTo: Endpoint.baseUrl)!
    
    static func parameters(extId: ExtId, auth: Auth) -> [String: Any] {
        var parameters: [String: Any] = [
            "ext_id" : extId.value,
            Endpoint.keyCid : auth.cid
        ]
        let signature = Endpoint.sign(parameters: parameters, path: WhatsNewEndpoint.path, auth: auth)
        parameters[Endpoint.keySign] = signature
        return parameters
    }
}

struct WhatsNewResponse: Codable {
    let whatsnew: WhatsNewList
}

struct WhatsNewList: Codable {
    let extId: ExtId
    let list: [WhatsNew]
    let total: Int
    let store: String
    let page: Page

    enum CodingKeys: String, CodingKey {
        case extId = "ext_id"
        case list
        case total
        case store
        case page
    }
}

struct WhatsNew: Codable {
    let releaseDate: String
    let lang: String
    let created: Date
    let whatsnew: String
    let id: Int
    let version: String
    let country: String
    
    enum CodingKeys: String, CodingKey {
        case releaseDate = "release_date"
        case lang
        case created
        case whatsnew
        case id
        case version
        case country
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try map.decode(.id) ?? 0
        self.releaseDate = try map.decode(.releaseDate) ?? ""
        self.version = try map.decode(.version) ?? ""
        self.whatsnew = try map.decode(.whatsnew) ?? ""
        self.lang = try map.decodeIfPresent(.lang) ?? ""
        let created = try map.decode(String.self, forKey: .created)
        self.created = Endpoint.toDate(created)
        self.country = try map.decodeIfPresent(.country) ?? ""
    }
}
