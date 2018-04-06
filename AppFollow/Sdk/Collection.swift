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
    static let empty = Collection(id: CollectionId.empty, count: IntValue.zero, countries: "", languages: "", title: "", created: "")
    
    let id: CollectionId
    let count: IntValue
    let countries: String
    let languages: String
    let title: String
    let created: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case count = "count_apps"
        case countries
        case languages
        case title
        case created
    }
}
