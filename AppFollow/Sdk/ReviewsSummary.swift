//
//  ReviewsSummary.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

class ReviewsSummaryEndpoint {
    static let path = "/reviews/summary"
    static let url = URL(string: ReviewsSummaryEndpoint.path, relativeTo: Endpoint.baseUrl)!
    
    static func parameters(extId: ExtId, from: Date, to: Date, auth: Auth) -> [String: Any] {
        var parameters: [String: Any] = [
            "ext_id" : extId.value,
            "from": Endpoint.date(from),
            "to": Endpoint.date(to),
            Endpoint.keyCid : auth.cid
        ]
        let signature = Endpoint.sign(parameters: parameters, path: ReviewsSummaryEndpoint.path, auth: auth)
        parameters[Endpoint.keySign] = signature
        return parameters
    }
}

struct ReviewsSummary: Codable {

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
