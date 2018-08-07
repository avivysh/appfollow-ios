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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard 
            let userInfo = response.notification.request.content.userInfo as? [String:AnyObject],
            let payload = Payload(userInfo: userInfo)
        else {
            log.error("Cannot parse userInfo: \(response.notification.request.content.userInfo.debugDescription)")
            completionHandler()
            return
        }
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        log.info("Received payload: \(response.notification.request.content.userInfo.debugDescription)")
        
        AppDelegate.provide.stateRefresh.refresh()
        
        if payload.isValid {
            PayloadNavigation(payload: payload).perform {
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
