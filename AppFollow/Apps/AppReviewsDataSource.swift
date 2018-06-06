//
//  AppReviewsDataSource.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 01/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import Snail

class AppReviewsDataSource: NSObject, AppSectionDataSource {
    private var reviews: [Review] = []
    private let app: App
    private let auth: AuthProvider

    let refreshed = Observable<NextOrError<Bool>>()
    private var loaded = false
    
    init(app: App, auth: AuthProvider) {
        self.app = app
        self.auth = auth
        super.init()
        
        self.refreshed.subscribe(onNext: { _ in self.loaded = true })
    }
    
    func reviewFor(indexPath: IndexPath) -> Review {
        return self.reviews[indexPath.row]
    }
    
    func reload() {
        ApiRequest(route: ReviewsRoute(extId: app.extId, store: app.store), auth: self.auth).get {
            (response: AppReviewsResponse?, error) in
            if let reviews = response?.reviews.list {
                self.reviews = reviews
            }
            self.refreshed.on(.next(NextOrError(error != nil, error)))
        }
    }
    
    func activate() {
        if self.loaded {
            self.refreshed.on(.next(NextOrError(true)))
            return
        }
        
        self.reload()
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        
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
