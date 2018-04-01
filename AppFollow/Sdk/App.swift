//
//  App.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

class AppsEndpoint {
    
    static let path = "/apps"
    static let url = URL(string: AppsEndpoint.path, relativeTo: Endpoint.baseUrl)!
    
    static func parameters(auth: Auth) -> [String: Any] {
        var parameters: [String: Any] = [ Endpoint.keyCid : auth.cid ]
        let signature = Endpoint.sign(parameters: parameters, path: AppsEndpoint.path, auth: auth)
        parameters[Endpoint.keySign] = signature
        return parameters
    }
}

class AppEndpoint {
    static let path = "/apps/app"
    static let url = URL(string: AppEndpoint.path, relativeTo: Endpoint.baseUrl)!
    
    static func parameters(collectionId: Int, auth: Auth) -> [String: Any] {
        var parameters: [String: Any] = [
            "apps_id" : collectionId,
            Endpoint.keyCid : auth.cid
        ]
        let signature = Endpoint.sign(parameters: parameters, path: AppEndpoint.path, auth: auth)
        parameters[Endpoint.keySign] = signature
        return parameters
    }
}

struct CollectionResponse: Codable {
    let apps: [App]
    
    enum CodingKeys: String, CodingKey {
        case apps = "apps_app"
    }
}

struct App: Codable {
    
    static let empty = App(id: 0, details: AppDetails.empty, reviewsCount: 0, whatsNewCount: 0, created: "", isFavorite: 0, store: "")

    let id: Int
    let details: AppDetails
    let reviewsCount: Int
    let whatsNewCount: Int
    let created: String
    let isFavorite: Int
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
}

struct AppDetails: Codable {
    
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
