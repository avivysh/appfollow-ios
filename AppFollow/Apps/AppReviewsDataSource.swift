//
//  AppReviewsDataSource.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 01/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

class AppReviewsDataSource: NSObject, AppViewDataSource {
    private var reviews: [Review] = []
    private let app: App
    private let auth: Auth

    private var loaded = false
    var dataSourceRefreshComplete = {}

    init(app: App, auth: Auth) {
        self.app = app
        self.auth = auth
    }
    
    func reload() {
        self.reload {
            self.loaded = true
            self.dataSourceRefreshComplete()
        }
    }
    
    func dataSourceBecomeActive() {
        if (self.loaded) {
            return
        }
        
        self.reload {
            self.loaded = true
            self.dataSourceRefreshComplete()
        }
    }
    
    private func reload(complete: @escaping () -> Void) {
        let parameters = ReviewsEndpoint.parameters(extId: app.extId, auth: self.auth)
        ApiRequest(url: ReviewsEndpoint.url, parameters: parameters).send {
            (response: AppReviewsResponse?) in
            if let reviews = response?.reviews.list {
                self.reviews = reviews.sorted(by: { (lr, rr) -> Bool in
                    lr.modified < rr.modified
                })
            }
            complete()
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        let review = reviews[indexPath.row]
        cell.bind(review: review, app: self.app)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Reviews"
    }
    
}
