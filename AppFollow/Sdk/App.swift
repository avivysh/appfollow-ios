//
//  App.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation


struct CollectionResponse: Codable {
    let apps: [App]
    
    enum CodingKeys: String, CodingKey {
        case apps = "apps_app"
    }
}

struct App: Codable {
    let id: Int
    let details: AppDetails
    let reviewsCount: Int
    let whatsNewCount: Int
    let created: String
    let isFavorite: Int
    let store: String
    
    enum CodingKeys: String, CodingKey {
        case id = "app_id"
        case details = "app"
        case reviewsCount = "count_reviews"
        case whatsNewCount = "count_whatsnew"
        case created
        case isFavorite = "is_favorite"
        case store
    }
}

struct AppDetails: Codable {
    let publisher: String
    let country: String
    let extId: String
    let genre: String
    let hasIap: Int
    let icon: String
    let id: Int
    let kind: String
    let lang: String
    let releaseDate: String
    let size: Double
    let title: String
    let type: String
    let url: String
    let version: String
    
    
    enum CodingKeys: String, CodingKey {
        case publisher = "artist_name"
        case country
        case extId = "ext_id"
        case genre
        case hasIap = "has_iap"
        case icon
        case id
        case kind
        case lang
        case releaseDate = "release_date"
        case size
        case title
        case type
        case url
        case version
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        self.publisher = try map.decode(.publisher) ?? ""
        self.country = try map.decode(.country) ?? ""
        self.genre = try map.decode(.genre) ?? ""
        var extId = ""
        if let value = try? map.decode(String.self, forKey: .extId) {
            extId = value
        } else if let value = try? map.decode(Int.self, forKey: .extId) {
            extId = String(value)
        }
        self.extId = extId
        self.hasIap = try map.decode(.hasIap) ?? 0
        self.icon = try map.decode(.icon) ?? ""
        self.id = try map.decode(.id) ?? 0
        self.kind = try map.decode(.kind) ?? ""
        self.lang = try map.decode(.lang) ?? ""
        self.releaseDate = try map.decode(.releaseDate) ?? ""
        self.size = try map.decode(.size) ?? 0
        self.title = try map.decode(.title) ?? ""
        self.type = try map.decode(.type) ?? ""
        self.url = try map.decode(.url) ?? ""
        self.version = try map.decode(.version) ?? ""
    }
}
