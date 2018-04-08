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

    var isValid: Bool {
        get { return self.extId.isEmpty || !(self.reviewId.isEmpty && self.extId.isEmpty) }
    }

    init(message: String, badge: Int, extId: ExtId, reviewId: ReviewId) {
        self.message = message
        self.badge = badge
        self.extId = extId
        self.reviewId = reviewId
    }

    convenience init?(userInfo: [String:AnyObject]) {
        guard 
            let apsInfo = userInfo["aps"] as? [String:AnyObject],
            let message = apsInfo["alert"] as? String,
            let badge = apsInfo["badge"] as? Int        
        else { return nil }

        let extId = userInfo["ext_id"] ?? ExtId.empty
        let reviewId = userInfo["review_id"] ?? ReviewId.empty

        self.init(message: message, badge: badge, extId: extId, reviewId: reviewId)
    }
}