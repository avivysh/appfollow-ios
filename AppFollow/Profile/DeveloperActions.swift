//
//  DeveloperActions.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 13/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import SwiftyBeaver
import UserNotifications

private func fetchReview(completion: @escaping (_ review: Review?,_ app: App,_ collection: Collection) -> Void) {
    let collection = AppDelegate.provide.store.collections.random()
    if let app = AppDelegate.provide.store.apps[collection.id]?.random() {
        let auth = AppDelegate.provide.auth
        ApiRequest(route: ReviewsRoute(extId: app.extId), auth: auth).get(completion: {
            (response: AppReviewsResponse?, _) in
            if let review = response?.reviews.list.first {
                completion(review, app, collection)
            } else {
                completion(nil, app, collection)
            }
        })
    }
}

class LocalNotificationAction: UIAlertAction {
    private weak var view: UIView?
    
    convenience init(view: UIView) {
        self.init(title: "Local notification", style: .default, handler: LocalNotificationAction.handler)
        self.view = view
    }
    static private let handler: ((UIAlertAction) -> Void) = {
        action in
        let testAction = action as! LocalNotificationAction
        testAction.view?.makeToast("Fetching a review")

        fetchReview { review, app, collection in
            if review == nil {
                testAction.view?.makeToast("Error: no review")
                return
            }
            let body = PushTest(review: review!, app: app, collection: collection)
            let content = UNMutableNotificationContent()
            content.title = app.details.title
            content.body = body.text
            content.userInfo = [
                "aps": [
                    "alert": body.text,
                    "badge": 1,
                ],
                "ext_id": app.extId.value,
                "review_id": review!.reviewId.value
            ]
            
            let request = UNNotificationRequest(identifier: "TestLocal", content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false))
            
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error : Error?) in
                if let theError = error {
                    log.error(theError.localizedDescription)
                    testAction.view?.makeToast("Error: \(theError.localizedDescription)")
                }
            }
        }
    }
}

class PushTestAction: UIAlertAction {
    private weak var view: UIView?

    convenience init(view: UIView) {
        self.init(title: "Test push", style: .default, handler: PushTestAction.handler)
        self.view = view
    }

    static private let handler: ((UIAlertAction) -> Swift.Void) = { action in
        let pushTestAction = action as! PushTestAction
        pushTestAction.view?.makeToast("Fetching a review")
        fetchReview { review, app, collection in
            if review == nil {
                 pushTestAction.view?.makeToast("Error: no review")
            } else {
                let auth = AppDelegate.provide.auth
                let body = PushTest(review: review!, app: app, collection: collection)
                ApiRequest(route: PushTestRoute(cid: auth.actual.cid), auth: auth).post(body: body) {
                    error in
                    
                    if error == nil {
                        pushTestAction.view?.makeToast("Push sent")
                    } else {
                        pushTestAction.view?.makeToast("Error: \(error?.localizedDescription ?? "Unknown")")
                    }
                }
            }
        }
    }
}

class SendLogsAction: UIAlertAction {
    private weak var viewController: UIViewController?
    
    convenience init(viewController: UIViewController) {
        self.init(title: "Send logs", style: .default, handler: SendLogsAction.handler)
        self.viewController = viewController
    }

    static private let handler: ((UIAlertAction) -> Swift.Void) = { action in
        let sendLogsAction = action as! SendLogsAction
        guard let logFileUrl = log.fileDestinations.first?.logFileURL
        else {
            return
        }
        let activity = UIActivityViewController(activityItems: [logFileUrl], applicationActivities: nil)
        sendLogsAction.viewController?.present(activity, animated: true, completion: nil)
    }
}
