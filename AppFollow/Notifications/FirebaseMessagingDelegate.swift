//
//  FirebaseMessagingDelegate
//  AppFollow
//
//  Created by Alexander Gavrishev on 07/08/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation
import FirebaseMessaging
import FirebaseInstanceID
import SwiftyBeaver

class FirebaseMessagingDelegate: NSObject, MessagingDelegate {
    
    override init() {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                log.error("Error fetching remote instange ID: \(error)")
            } else if let fcmToken = result?.token {
                log.debug("Remote instance ID token: \(fcmToken)")
                AppDelegate.provide.push.registerToken(fcmToken)
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        log.debug("didReceiveRegistrationToken: \(fcmToken)")
        AppDelegate.provide.push.registerToken(fcmToken)
    }
    
}
