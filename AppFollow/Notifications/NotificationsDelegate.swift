//
//  NotificationsDelegate.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 05/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation
import UserNotifications
import FirebaseMessaging

class NotificationsDelegate: NSObject, UNUserNotificationCenterDelegate {
    private lazy var payloadNavigation = PayloadNavigation()
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard 
            let userInfo = response.notification.request.content.userInfo as? [String:AnyObject],
            let payload = Payload(userInfo: userInfo)
        else {
            log.error("[PUSH] Cannot parse userInfo: \(response.notification.request.content.userInfo.debugDescription)")
            completionHandler()
            return
        }
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        log.info("[PUSH] Received payload: \(response.notification.request.content.userInfo.debugDescription), action: \(response.actionIdentifier), isValid: \(payload.isValid)")
        
        if payload.isValid {
            self.payloadNavigation.perform(payload: payload) {
                completionHandler()
            }
        } else {
            completionHandler()
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)

        completionHandler(.alert)
    }
}
