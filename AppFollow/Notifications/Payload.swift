//
//  Payload.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 05/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

struct Payload {
    let message: String
    let badge: Int
    let extId: ExtId
    let reviewId: ReviewId
    let type: String
    
    var isValid: Bool {
        get { return self.extId.isEmpty || !(self.reviewId.isEmpty && self.extId.isEmpty) }
    }

    init(message: String, badge: Int, extId: ExtId, reviewId: ReviewId, type: String) {
        self.message = message
        self.badge = badge
        self.extId = extId
        self.reviewId = reviewId
        self.type = type
    }

    init?(userInfo: [String:Any]) {
        guard 
            let apsInfo = userInfo["aps"] as? [String:Any],
            let message = apsInfo["alert"] as? String,
            let badge = apsInfo["badge"] as? Int        
        else { return nil }

        let extId = ExtId(from: userInfo["ext_id"] ?? "")
        let reviewId = ReviewId(from: userInfo["review_id"] ?? "")
        let type = userInfo["type"] as? String ?? ""
        
        self.init(message: message, badge: badge, extId: extId, reviewId: reviewId, type: type)
    }
}
