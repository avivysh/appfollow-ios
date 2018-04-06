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
    let collectionId: CollectionId
    // MARK: EndpointRoute
    let path = "/apps/app"
    var parameters: [String: Any] { get {
        return [
            "apps_id" : collectionId.value
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
    static let empty = App(id: AppId.empty, details: AppDetails.empty, reviewsCount: IntValue.zero, whatsNewCount: IntValue.zero, created: Date.unknown, isFavorite: BoolValue.false, store: "")

    let id: AppId
    let details: AppDetails
    let reviewsCount: IntValue
    let whatsNewCount: IntValue
    let created: Date
    let isFavorite: BoolValue
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
    
    init(id: AppId, details: AppDetails, reviewsCount: IntValue, whatsNewCount: IntValue, created: Date, isFavorite: BoolValue, store: String) {
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
        self.id = try map.decode(.id) ?? AppId.empty
        self.details = try map.decode(.details) ?? AppDetails.empty
        self.reviewsCount = try map.decode(.reviewsCount)
        self.whatsNewCount = try map.decode(.whatsNewCount)
        let created = try map.decode(String.self, forKey: .created)
        self.created = DateFormatter.date(ymdhms: created)
        self.isFavorite = try map.decode(BoolValue.self, forKey: .isFavorite)
        self.store = try map.decode(.store) ?? ""
    }
}

struct AppDetails: Decodable {
    
    static let empty = AppDetails(publisher: "", country: "", extId: ExtId.empty, genre: "", hasIap: BoolValue.false, icon: "", id: AppId.empty, kind: "", lang: "", released: Date.unknown, size: DoubleValue.zero, title: "", type: "", url: "", version: "")
    
    let publisher: String
    let country: String
    let extId: ExtId
    let genre: String
    let hasIap: BoolValue
    let icon: String
    let id: AppId
    let kind: String
    let lang: String
    let released: Date
    let size: DoubleValue
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
        case released = "release_date"
        case size
        case title
        case type
        case url
        case version
    }
    
    init(publisher: String, country: String, extId: ExtId, genre: String, hasIap: BoolValue, icon: String, id: AppId, kind: String, lang: String, released: Date, size: DoubleValue, title: String, type: String, url: String, version: String) {
        self.publisher = publisher
        self.country = country
        self.extId = extId
        self.genre = genre
        self.hasIap = hasIap
        self.icon = icon
        self.id = id
        self.kind = kind
        self.lang = lang
        self.released = released
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
        self.hasIap = try map.decode(.hasIap)
        self.icon = try map.decode(.icon) ?? ""
        self.id = try map.decode(.id)
        self.kind = try map.decode(.kind) ?? ""
        self.lang = try map.decode(.lang) ?? ""
        let releaseDate = try map.decode(.released) ?? ""
        self.released = DateFormatter.date(ymd: releaseDate)
        self.size = try map.decode(.size)
        self.title = try map.decode(.title) ?? ""
        self.type = try map.decode(.type) ?? ""
        self.url = try map.decode(.url) ?? ""
        self.version = try map.decode(.version) ?? ""
    }
}
