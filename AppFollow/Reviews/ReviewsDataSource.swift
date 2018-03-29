//
//  ReviewsDataSource.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

class ReviewsDataSource: NSObject, UITableViewDataSource {

    private var reviews: [Review] = []
    private var apps: [Int: App] = [:]
    
    func reload(complete: @escaping () -> Void) {
        
        let collections = AppDelegate.provide.store.collections
        let auth = AppDelegate.provide.auth

        self.apps = AppDelegate.provide.store.apps.reduce(into: [Int: App](), { (result, pair) in
            let collectinApps = pair.value
            
            for app in collectinApps {
                result[app.id] = app
            }
        })
        
        let group = DispatchGroup()
        var allReviews = [Review]()
        for collection in collections {
            let parameters = CollectionReviewsEndpoint.parameters(collectionName: collection.title, auth: auth)
            group.enter()
            ApiRequest(url: CollectionReviewsEndpoint.url(collectionName: collection.title), parameters: parameters).send {
                (response: ReviewsResponse?) in
                if let reviews = response?.reviews {
                    group.leave()
                    allReviews.append(contentsOf: reviews)
                    
                }
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
       group.notify(queue: .main) {
            self.reviews = allReviews.sorted(by: { (lr, rr) -> Bool in
                let lcreated = dateFormatter.date(from: lr.created) ?? Date(timeIntervalSince1970: 100)
                let rcreated = dateFormatter.date(from: rr.created) ?? Date(timeIntervalSince1970: 100)
                return lcreated > rcreated
            })
            complete();
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        let review = reviews[indexPath.row]
        let app = apps[review.appId] ?? App.empty
        cell.bind(review: review, app: app)
        return cell
    }
}
