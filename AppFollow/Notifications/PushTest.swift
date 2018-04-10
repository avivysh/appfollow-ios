//
//  PushTest.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 09/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

struct PushApp: Encodable {
    let link: String
    let icon: String
    let title: String
    let extId: ExtId
    
    enum CodingKeys: String, CodingKey {
        case link
        case icon
        case title
        case extId = "ext_id"
    }
    
    init(app: App) {
        self.link = app.details.url
        self.icon = app.details.icon
        self.title = app.details.title
        self.extId = app.extId
    }
}

struct PushReview: Encodable {
    let replyLink: String
    let reviewId: ReviewId
    let title: String
    let store: String
    let country: String
    let version: String
    let content: String
    let author: String
    let app: PushApp
    let rating: Double
    let date: String
    let countryCode: String
    let permalink: String
    
    enum CodingKeys: String, CodingKey {
        case replyLink
        case reviewId = "review_id"
        case title
        case store
        case country
        case version
        case content
        case author
        case app
        case rating
        case date
        case countryCode = "country_code"
        case permalink
    }
    
    init(review: Review, app: App, collection: Collection) {
        let collectionName = collection.title.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        self.replyLink = "https://watch.appfollow.io/apps/\(collectionName)/reviews/\(app.id)?review_id=\(review.reviewId)&s=app"
        self.reviewId = review.reviewId
        self.title = review.title
        self.store = review.store
        self.country = ""
        self.content = review.content
        self.version = review.version
        self.author = review.author
        self.app = PushApp(app: app)
        self.rating = review.rating.value
        self.date = review.date.isValid ? review.date.ymd : ""
        self.countryCode = ""
        self.permalink = ""
    }
}

struct PushTest: Encodable {
    let reviews: [PushReview]
    let text: String
    
    init(review: Review, app: App, collection: Collection) {
        self.reviews = [PushReview(review: review, app: app, collection: collection)]
        self.text = "\(app.details.title) \(review.store) \(review.author) \(review.title) \(review.content)"
    }
}

struct PushTestRoute: EndpointRoute {
    let cid: Int
    let path = "/send_review"
    var parameters: [String : Any] {
        return [
            "cid": self.cid,
            "dev103": 1
        ]
    }
}

