//
//  Review.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

struct Page: Codable {
    let next: Int?
    let current: Int
    let prev: Int?
    let total: Int
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

private let dateFormatter = DateFormatter.create(format: "yyyy-MM-dd HH:mm:ss")

struct Review: Codable {
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
    let ratingPrevious: Int
    let appVersion: String
    let author: String
    let wasChanged: Int
    let created: String
    let updated: String
    let isAnswer: Int
    
    var modified: Date {
        get {
            var modified: Date?
            if (!updated.isEmpty) {
                modified = dateFormatter.date(from: updated)
            }
            if (modified == nil) {
                modified = dateFormatter.date(from: created)
            }
            return modified ?? Date(timeIntervalSince1970: 100)
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
        case appVersion = "app_version"
        case author
        case wasChanged = "was_changed"
        case created
        case updated
        case isAnswer = "is_answer"
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        // App reviews optional
        self.id = try map.decodeIfPresent(.id) ?? 0
        self.appId = try map.decodeIfPresent(.appId) ?? 0
        self.extId = try map.decodeIfPresent(.extId) ?? ExtId.empty
        self.locale = try map.decodeIfPresent(.locale) ?? ""
        self.ratingPrevious = try map.decodeIfPresent(.ratingPrevious) ?? 0
        self.updated = try map.decodeIfPresent(.updated) ?? ""
        //
        self.store = try map.decode(.store) ?? ""
        self.reviewId = try map.decode(.reviewId) ?? ReviewId.empty
        self.userId = try map.decode(.userId) ?? UserId.empty
        self.date = try map.decode(.date) ?? ""
        self.title = try map.decode(.title) ?? ""
        self.content = try map.decode(.content) ?? ""
        self.rating = try map.decode(.rating) ?? 0
        self.appVersion = try map.decode(.appVersion) ?? ""
        self.author = try map.decode(.author) ?? ""
        self.wasChanged = try map.decode(.wasChanged) ?? 0
        self.created = try map.decode(.created) ?? ""
        self.isAnswer = try map.decode(.isAnswer) ?? 0
    }
}


