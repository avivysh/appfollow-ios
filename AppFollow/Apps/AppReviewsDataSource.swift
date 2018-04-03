//
//  AppReviewsDataSource.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 01/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

class AppReviewsDataSource: NSObject, AppSectionDataSource {
    
    private var reviews: [Review] = []
    private let app: App
    private let auth: Auth

    private var loaded = false
    weak var delegate: AppSectionDataSourceDelegate?
    
    init(app: App, auth: Auth) {
        self.app = app
        self.auth = auth
    }
    
    func reviewFor(indexPath: IndexPath) -> Review {
        return self.reviews[indexPath.row]
    }
    
    func reload() {
        self.reload {
            self.loaded = true
            self.delegate?.dataSourceCompleteRefresh()
        }
    }
    
    func activate() {
        if (self.loaded) {
            return
        }
        
        self.reload {
            self.loaded = true
            self.delegate?.dataSourceCompleteRefresh()
        }
    }
    
    private func reload(complete: @escaping () -> Void) {
        ApiRequest(route: ReviewsRoute(extId: app.extId), auth: self.auth).get {
            (response: AppReviewsResponse?, _) in
            if let reviews = response?.reviews.list {
                self.reviews = reviews
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
