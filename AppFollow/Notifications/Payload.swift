//
//  Payload.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 05/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation
import FirebaseInstanceID

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
        guard let apsInfo = userInfo["aps"] as? [String:Any] else { return nil }

        var message = ""
        if let alert = apsInfo["alert"] as? [String:Any] {
            message = alert["body"] as? String ?? ""
        } else {
            message = apsInfo["alert"] as? String ?? ""
        }
        
        let extId = ExtId(from: userInfo["ext_id"] ?? "")
        let reviewId = ReviewId(from: userInfo["review_id"] ?? "")
        let type = userInfo["type"] as? String ?? ""
        let badge = apsInfo["badge"] as? Int ?? 0

        self.init(message: message, badge: badge, extId: extId, reviewId: reviewId, type: type)
    }
}
