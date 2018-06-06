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
    let store: String

    init(extId: ExtId, reviewId: ReviewId, store: String) {
        self.extId = extId
        self.reviewId = reviewId
        self.store = store
    }
    
    init(extId: ExtId, store: String) {
        self.init(extId: extId, reviewId: ReviewId.empty, store: store)
    }
    
    // MARK: EndpointRoute
    let path = "/reviews"
    var parameters: [String : Any] { get {
        var parameters: [String: Any] = [
            "ext_id" : extId.value,
            "store": store
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
        get {
            let encoded = collectionName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            return "/\(encoded)/reviews"
        }
    }
    var parameters: [String: Any] {
        get {
            return [
                "from": from.ymd,
                "to": to.ymd
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
    
    static let empty = Review(id: ValueId.empty, appId: AppId.empty, extId: ExtId.empty, locale: "", rating: DoubleValue.zero, ratingPrevious: DoubleValue.zero, store: "", reviewId: ReviewId.empty, userId: UserId.empty, date: Date.unknown, title: "", content: "", version: "", author: "", wasChanged: BoolValue.false, created: Date.unknown, updated: Date.unknown, answer: ReviewAnswer.empty, history: [])
    
    let id: ValueId
    let store: String
    let appId: AppId
    let extId: ExtId
    let reviewId: ReviewId
    let locale: String
    let userId: UserId
    let date: Date
    let title: String
    let content: String
    let rating: DoubleValue
    let ratingPrevious: DoubleValue
    let version: String
    let author: String
    let wasChanged: BoolValue
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
    
    init(id: ValueId, appId: AppId, extId: ExtId, locale: String, rating: DoubleValue, ratingPrevious: DoubleValue, store: String, reviewId: ReviewId, userId: UserId, date: Date, title: String, content: String, version: String, author: String, wasChanged: BoolValue, created: Date, updated: Date, answer: ReviewAnswer, history: [Review]) {
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
        self.id = try map.decodeIfPresent(.id) ?? ValueId.empty
        self.appId = try map.decodeIfPresent(.appId) ?? AppId.empty
        self.extId = try map.decodeIfPresent(.extId) ?? ExtId.empty
        self.locale = try map.decodeIfPresent(.locale) ?? ""
        self.ratingPrevious = try map.decodeIfPresent(.ratingPrevious) ?? DoubleValue.zero
        let updated = try map.decodeIfPresent(String.self, forKey: .updated) ?? ""
        self.updated = updated.isEmpty ? Date.unknown : DateFormatter.date(ymdhms: updated)
        // History optional
        self.store = try map.decodeIfPresent(.store) ?? ""
        self.version = try map.decodeIfPresent(.version) ?? ""
        // Answer
        let answerDate = try map.decodeIfPresent(.answerDate) ?? ""
        let answerText = try map.decodeIfPresent(.answerText) ?? ""
        let answered = try map.decodeIfPresent(BoolValue.self, forKey: .answered) ?? BoolValue.false
        self.answer = ReviewAnswer(answered: answered.value, date: answerDate, text: answerText)
        //
        self.reviewId = try map.decode(.reviewId) ?? ReviewId.empty
        self.userId = try map.decode(.userId) ?? UserId.empty
        let date = try map.decode(String.self, forKey: .date)
        self.date = DateFormatter.date(ymd: date)
        self.title = try map.decode(.title) ?? ""
        self.content = try map.decode(.content) ?? ""
        self.rating = try map.decode(.rating) ?? DoubleValue.zero
        self.author = try map.decode(.author) ?? ""
        self.wasChanged = try map.decode(BoolValue.self, forKey: .wasChanged)
        let created = try map.decodeIfPresent(String.self, forKey: .created) ?? ""
        self.created = created.isEmpty ? Date.unknown : DateFormatter.date(ymdhms: created)
        self.history = try map.decodeIfPresent(.history) ?? []
    }
}


