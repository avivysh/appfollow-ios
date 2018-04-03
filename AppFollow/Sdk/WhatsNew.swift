//
//  WhatsNew.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 02/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

struct WhatsNewRoute: EndpointRoute {
    let extId: ExtId
    // MARK: EndpointRoute
    let path = "/whatsnew"
    var parameters: [String : Any] { get { return [
        "ext_id"  : extId.value
    ]}}
}

struct WhatsNewResponse: Decodable {
    let whatsnew: WhatsNewList
}

struct WhatsNewList: Decodable {
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

struct WhatsNew: Decodable {
    let releaseDate: String
    let lang: String
    let created: Date
    let whatsnew: String
    let id: IntValue
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
        self.id = try map.decode(.id)
        self.releaseDate = try map.decode(.releaseDate) ?? ""
        self.version = try map.decode(.version) ?? ""
        self.whatsnew = try map.decode(.whatsnew) ?? ""
        self.lang = try map.decodeIfPresent(.lang) ?? ""
        let created = try map.decode(String.self, forKey: .created)
        self.created = DateFormatter.date(ymdhms: created)
        self.country = try map.decodeIfPresent(.country) ?? ""
    }
}
