//
//  App.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

struct AppsRoute: EndpointRoute {
    let path = "/apps"
    let parameters: [String: Any] = [:]
}

struct AppRoute: EndpointRoute {
    let collectionId: Int
    // MARK: EndpointRoute
    let path = "/apps/app"
    var parameters: [String: Any] { get {
        return [
            "apps_id" : collectionId
        ]}
    }
}

struct CollectionResponse: Decodable {
    let apps: [App]
    
    enum CodingKeys: String, CodingKey {
        case apps = "apps_app"
    }
}

struct App: Decodable {
    static let empty = App(id: 0, details: AppDetails.empty, reviewsCount: 0, whatsNewCount: 0, created: Date.unknown, isFavorite: false, store: "")

    let id: Int
    let details: AppDetails
    let reviewsCount: Int
    let whatsNewCount: Int
    let created: Date
    let isFavorite: Bool
    let store: String
    
    var extId: ExtId {
        get { return details.extId }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "app_id"
        case details = "app"
        case reviewsCount = "count_reviews"
        case whatsNewCount = "count_whatsnew"
        case created
        case isFavorite = "is_favorite"
        case store
    }
    
    init(id: Int, details: AppDetails, reviewsCount: Int, whatsNewCount: Int, created: Date, isFavorite: Bool, store: String) {
        self.id = id
        self.details = details
        self.reviewsCount = reviewsCount
        self.whatsNewCount = whatsNewCount
        self.created = created
        self.isFavorite = isFavorite
        self.store = store
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try map.decode(.id) ?? 0
        self.details = try map.decode(.details) ?? AppDetails.empty
        self.reviewsCount = try map.decode(.reviewsCount) ?? 0
        self.whatsNewCount = try map.decode(.whatsNewCount) ?? 0
        let created = try map.decode(String.self, forKey: .created)
        self.created = DateFormatter.date(ymdhms: created)
        let isFavorite = try map.decode(Int.self, forKey: .isFavorite)
        self.isFavorite = isFavorite == 1
        self.store = try map.decode(.store) ?? ""
    }
}

struct AppDetails: Decodable {
    
    static let empty = AppDetails(publisher: "", country: "", extId: ExtId.empty, genre: "", hasIap: 0, icon: "", id: 0, kind: "", lang: "", releaseDate: "", size: 0, title: "", type: "", url: "", version: "")
    
    let publisher: String
    let country: String
    let extId: ExtId
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
    
    init(publisher: String, country: String, extId: ExtId, genre: String, hasIap: Int, icon: String, id: Int, kind: String, lang: String, releaseDate: String, size: Double, title: String, type: String, url: String, version: String) {
        self.publisher = publisher
        self.country = country
        self.extId = extId
        self.genre = genre
        self.hasIap = hasIap
        self.icon = icon
        self.id = id
        self.kind = kind
        self.lang = lang
        self.releaseDate = releaseDate
        self.size = size
        self.title = title
        self.type = type
        self.url = url
        self.version = version
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        self.publisher = try map.decode(.publisher) ?? ""
        self.country = try map.decode(.country) ?? ""
        self.genre = try map.decode(.genre) ?? ""
        self.extId = try map.decode(.extId) ?? ExtId.empty
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
