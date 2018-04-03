//
//  Review.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

struct ReviewsRoute: EndpointRoute {
    let extId: ExtId
    let reviewId: ReviewId
    
    init(extId: ExtId, reviewId: ReviewId) {
        self.extId = extId
        self.reviewId = reviewId
    }
    
    init(extId: ExtId) {
        self.init(extId: extId, reviewId: ReviewId.empty)
    }
    
    // MARK: EndpointRoute
    let path = "/reviews"
    var parameters: [String : Any] { get {
        var parameters: [String: Any] = [
            "ext_id" : extId.value
        ]
        if !reviewId.isEmpty {
            parameters["review_id"] = reviewId.value
        }
        return parameters
    }}
}

struct CollectionReviewsRoute: EndpointRoute {
    let collectionName: String
    let from: Date
    let to: Date
    
    var path: String {
        get { return "/\(collectionName)/reviews" }
    }
    var parameters: [String: Any] {
        get {
            return [
                "from": from.ymd(),
                "to": to.ymd()
            ]
        }
    }
}

struct AppReviewsPage: Decodable {
    let extId: ExtId
    let page: Page
    let list: [Review]
    
    enum CodingKeys: String, CodingKey {
        case extId = "ext_id"
        case page
        case list
    }
}

struct AppReviewsResponse: Decodable {
    let reviews: AppReviewsPage
}

struct ReviewsResponse: Decodable {
    let reviews: [Review]
}

struct ReviewAnswer {
    
    static let empty = ReviewAnswer(answered: false, date: "", text: "")
    
    let answered: Bool
    let date: String
    let text: String

}

struct Review: Decodable {
    
    static let empty = Review(id: 0, appId: 0, extId: ExtId.empty, locale: "", rating: 0, ratingPrevious: 0, store: "", reviewId: ReviewId.empty, userId: UserId.empty, date: "", title: "", content: "", version: "", author: "", wasChanged: false, created: Date.unknown, updated: Date.unknown, answer: ReviewAnswer.empty, history: [])
    
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
    let answer: ReviewAnswer
    let history: [Review]
    
    var answered: Bool {
        get { return answer.answered }
    }
    
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
        case history = "reviews_history"
        case answered = "is_answer"
        case answerDate = "answer_date"
        case answerText = "answer_text"
    }
    
    init(id: Int, appId: Int, extId: ExtId, locale: String, rating: Double, ratingPrevious: Double, store: String, reviewId: ReviewId, userId: UserId, date: String, title: String, content: String, version: String, author: String, wasChanged: Bool, created: Date, updated: Date, answer: ReviewAnswer, history: [Review]) {
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
        self.updated = updated.isEmpty ? Date.unknown : DateFormatter.date(ymdhms: updated)
        // History optional
        self.store = try map.decodeIfPresent(.store) ?? ""
        self.version = try map.decodeIfPresent(.version) ?? ""
        // Answer
        let answerDate = try map.decodeIfPresent(.answerDate) ?? ""
        let answerText = try map.decodeIfPresent(.answerText) ?? ""
        let answered = (try map.decodeIfPresent(Int.self, forKey: .answered) ?? 0) == 1
        self.answer = ReviewAnswer(answered: answered, date: answerDate, text: answerText)
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
        self.created = created.isEmpty ? Date.unknown : DateFormatter.date(ymdhms: created)
        self.history = try map.decodeIfPresent(.history) ?? []
    }
}


