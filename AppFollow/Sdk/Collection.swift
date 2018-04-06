//
//  Collection.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

struct CollectionsResponse: Decodable {
    let collections: [Collection]
    
    enum CodingKeys: String, CodingKey {
        case collections = "apps"
    }
}
 
struct Collection: Decodable {
    static let empty = Collection(id: CollectionId.empty, count: IntValue.zero, countries: "", languages: "", title: "", created: Date.unknown)
    
    let id: CollectionId
    let count: IntValue
    let countries: String
    let languages: String
    let title: String
    let created: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case count = "count_apps"
        case countries
        case languages
        case title
        case created
    }
    
    init(id: CollectionId, count: IntValue, countries: String, languages: String, title: String, created: Date) {
        self.id = id
        self.count = count
        self.countries = countries
        self.languages = languages
        self.title = title
        self.created = created
    }
    
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try map.decode(.id) ?? CollectionId.empty
        self.count = try map.decode(.count) ?? IntValue.zero
        self.countries = try map.decode(.countries) ?? ""
        self.languages = try map.decode(.languages) ?? ""
        self.title = try map.decode(.title) ?? ""
        let created = try map.decodeIfPresent(.created) ?? ""
        self.created = DateFormatter.date(ymd: created)
    }
}
