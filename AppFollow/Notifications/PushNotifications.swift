//
//  PushNotifications.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 04/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import UserNotifications

private let notificationTypes: UNAuthorizationOptions = [.alert, .badge, .sound]

private struct PushRoute: EndpointRoute {
    let deviceToken: String
    let path = "/firebase"
    var parameters: [String : Any] {
        get {
            return [ "token": deviceToken ]
        }
    }
}

struct PushResponse: Decodable { }

class PushNotifications {

    private let auth: AuthProvider
    init(auth: AuthProvider) {
        self.auth = auth
    }

    func registerForRemoteNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: notificationTypes) { (granted, error) in
            if (granted) {
                DispatchQueue.main.async {
                    // must be called in main thread only
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func registerToken(_ fcmToken: String) {
        ApiRequest(route: PushRoute(deviceToken: fcmToken), auth: self.auth).get {
            (result: PushResponse?, error) in
            if error != nil {
                log.error(error!)
            }
        }
    }

    func removeToken() {
        ApiRequest(route: PushRoute(deviceToken: ""), auth: self.auth).get {
            (result: PushResponse?, error) in
            if error != nil {
                log.error(error!)
            }
        }
    }
}
