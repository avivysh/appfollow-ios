//
//  ReviewsSummary.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

struct ReviewsSummaryRoute: EndpointRoute {
    let extId: ExtId
    let from: Date
    let to: Date
    // MARK: EndpointRoute
    let path = "/reviews/summary"
    var parameters: [String: Any] { get { return [
        "ext_id" : extId.value,
        "from": from.ymd,
        "to": to.ymd
        ]}
    }
}

struct ReviewsSummary: Decodable {
    let extId: ExtId
    let reviewsCount: Int
    let reviewsAverage: Double
    let ratingCount: Int
    let ratingAverage: Double
    let from: String
    let to: String
    
    enum CodingKeys: String, CodingKey {
        case extId = "ext_id"
        case reviewsCount = "reviews_cnt"
        case reviewsAverage = "reviews_avg"
        case ratingCount = "rating_cnt"
        case ratingAverage = "rating_avg"
        case from
        case to
    }

}
