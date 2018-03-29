//
//  Collection.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

struct CollectionsResponse: Codable {
    let collections: [Collection]
    
    enum CodingKeys: String, CodingKey {
        case collections = "apps"
    }
}
 
struct Collection: Codable {
    static let empty = Collection(id: 0, count: 0, countries: "", languages: "", title: "", created: "")
    
    let id: Int
    let count: Int
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
