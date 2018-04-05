//
//  NotificationsDelegate.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 05/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationsDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        guard let url = response.notification.request.content.userInfo["deeplink"] as? String,
            let deeplinkURL = URL(string: url)
            else {
                log.error("Cannot parse deeplink \(response.notification.request.content.userInfo.debugDescription)")
                completionHandler()
                return
        }
        log.info("Received deeplink: \(deeplinkURL.debugDescription)")
        
        let deeplink = Deeplink(url: deeplinkURL)
        if deeplink.isValid {
            DeeplinkNavigation(deeplink: deeplink).perform {
                completionHandler()
            }
        } else {
            completionHandler()
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler(.alert)
    }
}
