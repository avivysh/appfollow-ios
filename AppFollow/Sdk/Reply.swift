//
//  Reply.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 03/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

struct ReplyRoute: EndpointRoute {
    let extId: ExtId
    let reviewId: ReviewId
    let answer: String
    let store: String
    // MARK: EndpointRoute
    let path = "/reply"
    var parameters: [String: Any] {
        get { return [
            "ext_id" : extId.value,
            "review_id" : reviewId.value,
            "answer_text" : answer,
            "store": store
        ]}
    }
}

struct ReplyResponse: Decodable {
    let updated: String
}
