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
/*
     [
         AnyHashable("gcm.message_id"): 0:1534189568367460%c0a86cc6c0a86cc6,
         AnyHashable("ext_id"): com.Slack,
         AnyHashable("google.c.a.e"): 1,
         AnyHashable("google.c.a.ts"): 1534189568,
         AnyHashable("google.c.a.udt"): 0,
         AnyHashable("review_id"): gp:AOqpTOFoqw2BUSZ50kd2Q…oiJohFHtpjkA_WexBIgQVNY,
         AnyHashable("gcm.n.e"): 1,
         AnyHashable("aps"): {
            alert = {
                body = "Do you plan to add Ukraine localization";
                title = "\U0422\U0438\U0442\U043b\U0435";
            };
         },
         AnyHashable("google.c.a.c_id"): 1924512316514573324,
         AnyHashable("type"): review
     ]
 */
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
