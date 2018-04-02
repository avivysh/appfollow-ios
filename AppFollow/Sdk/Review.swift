//
//  Review.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

class ReviewsEndpoint {
    static let path = "/reviews"
    static let url = URL(string: ReviewsEndpoint.path, relativeTo: Endpoint.baseUrl)!

    static func parameters(extId: ExtId, auth: Auth) -> [String: Any] {
        return ReviewsEndpoint.parameters(extId: extId, reviewId: ReviewId.empty, auth: auth)
    }
    
    static func parameters(extId: ExtId, reviewId: ReviewId, auth: Auth) -> [String: Any] {
        var parameters: [String: Any] = [
            "ext_id" : extId.value,
            Endpoint.keyCid : auth.cid
        ]
        if !reviewId.isEmpty {
           parameters["review_id"] = reviewId.value
        }
        let signature = Endpoint.sign(parameters: parameters, path: ReviewsEndpoint.path, auth: auth)
        parameters[Endpoint.keySign] = signature
        return parameters
    }
}

class CollectionReviewsEndpoint {
    //    static let path = "/reviews"
    //    static let url = URL(string: ReviewsSummaryEndpoint.path, relativeTo: Endpoint.baseUrl)!
    
    static func path(_ collectionName: String) -> String {
        return "/\(collectionName)/reviews"
    }
    
    static func url(collectionName: String) -> URL {
        return URL(string: CollectionReviewsEndpoint.path(collectionName), relativeTo: Endpoint.baseUrl)!
    }
    
    static func parameters(collectionName: String, from: Date, to: Date, auth: Auth) -> [String: Any] {
        var parameters: [String: Any] = [
            "from": Endpoint.date(from),
            "to": Endpoint.date(to),
            Endpoint.keyCid : auth.cid
        ]
        let signature = Endpoint.sign(parameters: parameters, path: CollectionReviewsEndpoint.path(collectionName), auth: auth)
        parameters[Endpoint.keySign] = signature
        return parameters
    }
}

struct AppReviewsPage: Codable {
    let extId: ExtId
    let page: Page
    let list: [Review]
    
    enum CodingKeys: String, CodingKey {
        case extId = "ext_id"
        case page
        case list
    }
}

struct AppReviewsResponse: Codable {
    let reviews: AppReviewsPage
}

struct ReviewsResponse: Codable {
    let reviews: [Review]
}

struct Review: Codable {
    
    static let empty = Review(id: 0, appId: 0, extId: ExtId.empty, locale: "", rating: 0, ratingPrevious: 0, store: "", reviewId: ReviewId.empty, userId: UserId.empty, date: "", title: "", content: "", version: "", author: "", wasChanged: false, created: Date.unknown, updated: Date.unknown, answered: false, answerDate: "", answer: "", history: [])
    
    let id: Int
    let store: String
    let appId: Int
    let extId: ExtId
    let reviewId: ReviewId
    let locale: String
    let userId: UserId
    let date: String
    let title: String
    let content: String
    let rating: Double
    let ratingPrevious: Double
    let version: String
    let author: String
    let wasChanged: Bool
    let created: Date
    let updated: Date
    let answered: Bool
    let answerDate: String
    let answer: String
    let history: [Review]
    
    var modified: Date {
        get {
            if (updated.isValid) {
                return updated
            }
            return created
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case store
        case appId = "app_id"
        case extId = "ext_id"
        case reviewId = "review_id"
        case locale
        case userId = "user_id"
        case date
        case title
        case content
        case rating
        case ratingPrevious = "rating_prev"
        case version = "app_version"
        case author
        case wasChanged = "was_changed"
        case created
        case updated
        case answered = "is_answer"
        case answerDate = "answer_date"
        case answer = "answer_text"
        case history = "reviews_history"
    }
    
    init(id: Int, appId: Int, extId: ExtId, locale: String, rating: Double, ratingPrevious: Double, store: String, reviewId: ReviewId, userId: UserId, date: String, title: String, content: String, version: String, author: String, wasChanged: Bool, created: Date, updated: Date, answered: Bool, answerDate: String, answer: String, history: [Review]) {
        self.id = id
        self.appId = appId
        self.extId = extId
        self.locale = locale
        self.rating = rating
        self.ratingPrevious = ratingPrevious
        self.store = store
        self.reviewId = reviewId
        self.userId = userId
        self.date = date
        self.title = title
        self.content = content
        self.version = version
        self.author = author
        self.wasChanged = wasChanged
        self.created = created
        self.updated = updated
        self.answered = answered
        self.answerDate = answerDate
        self.answer = answer
        self.history = history
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        // App reviews optional
        self.id = try map.decodeIfPresent(.id) ?? 0
        self.appId = try map.decodeIfPresent(.appId) ?? 0
        self.extId = try map.decodeIfPresent(.extId) ?? ExtId.empty
        self.locale = try map.decodeIfPresent(.locale) ?? ""
        self.ratingPrevious = try map.decodeIfPresent(.ratingPrevious) ?? 0
        let updated = try map.decodeIfPresent(String.self, forKey: .updated) ?? ""
        self.updated = updated.isEmpty ? Date.unknown : Endpoint.toDate(updated)
        self.answerDate = try map.decodeIfPresent(.answerDate) ?? ""
        self.answer = try map.decodeIfPresent(.answer) ?? ""
        // History optional
        self.store = try map.decodeIfPresent(.store) ?? ""
        self.version = try map.decodeIfPresent(.version) ?? ""
        //
        self.reviewId = try map.decode(.reviewId) ?? ReviewId.empty
        self.userId = try map.decode(.userId) ?? UserId.empty
        self.date = try map.decode(.date) ?? ""
        self.title = try map.decode(.title) ?? ""
        self.content = try map.decode(.content) ?? ""
        self.rating = try map.decode(.rating) ?? 0
        self.author = try map.decode(.author) ?? ""
        self.wasChanged = try map.decode(Int.self, forKey: .wasChanged) == 1
        let created = try map.decodeIfPresent(String.self, forKey: .created) ?? ""
        self.created = created.isEmpty ? Date.unknown : Endpoint.toDate(created)
        self.answered = try map.decode(Int.self, forKey: .answered) == 1
        self.history = try map.decodeIfPresent(.history) ?? []
    }
}


