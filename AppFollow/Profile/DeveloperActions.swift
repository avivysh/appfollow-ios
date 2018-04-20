//
//  DeveloperActions.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 13/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import SwiftyBeaver

class PushTestAction: UIAlertAction {
    private weak var view: UIView?

    convenience init(view: UIView) {
        self.init(title: "Test push", style: .default, handler: PushTestAction.handler)
        self.view = view
    }

    static private let handler: ((UIAlertAction) -> Swift.Void) = { action in
        let pushTestAction = action as! PushTestAction
        let collection = AppDelegate.provide.store.collections.random()
        if let app = AppDelegate.provide.store.apps[collection.id]?.random() {
            let auth = AppDelegate.provide.auth
            ApiRequest(route: ReviewsRoute(extId: app.extId), auth: auth).get(completion: {
                (response: AppReviewsResponse?, _) in
                if let review = response?.reviews.list.first {
                    let body = PushTest(review: review, app: app, collection: collection)
                    ApiRequest(route: PushTestRoute(cid: auth.actual.cid), auth: auth).post(body: body) {
                        error in

                        if error == nil {
                            pushTestAction.view?.makeToast("Push sent")
                        } else {
                            pushTestAction.view?.makeToast("Error: \(error?.localizedDescription ?? "Unknown")")
                        }
                    }
                } else {
                    pushTestAction.view?.makeToast("Error: no review")
                }
            })
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
