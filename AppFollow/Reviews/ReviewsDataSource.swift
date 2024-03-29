//
//  ReviewsDataSource.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import Snail

private let sectionTitles: [DateSection:String] = [
    .today:"Today",
    .yesterday:"Yesterday",
    .thisWeek: "This week",
    .thisMonth: "This month",
    .older: "Older"
]

class ReviewsDataSource: NSObject, UITableViewDataSource {

    private var reviews: [DateSection:[Review]] = [:]
    private var apps: [AppId: App] = [:]
    private var sections: [DateSection] = []
    let refreshed = Observable<NextOrError<Bool>>()
    let filteredCollection = Variable<Collection?>(nil)
    
    override init() {
        super.init()
        AppDelegate.provide.store.refreshed.subscribe(
            onNext: { [weak self] result in
                guard let self = self else { return }
                let filtered = self.filteredCollection.value
                let collections = filtered == nil ? AppDelegate.provide.store.collections : [filtered!]
                self.reload(collections: collections) { [weak self] in
                    self?.refreshed.on(.next(result))
                }
            }
        )
    }
    
    func reviewFor(indexPath: IndexPath) -> Review {
        let dateSection = sections[indexPath.section]
        return reviews[dateSection]![indexPath.row]
    }
    
    func appFor(review: Review) -> App {
        return apps[review.appId] ?? App.empty
    }
    
    func filter(collection: Collection?) {
        let collections = collection == nil ? AppDelegate.provide.store.collections : [collection!]
        self.filteredCollection.value = collection
        self.reload(collections: collections) { [weak self] in
            self?.refreshed.on(.next(NextOrError(true)))
        }
    }
    
    private func reload(collections: Collections, complete: @escaping () -> Void) {
        let auth = AppDelegate.provide.auth
        
        let group = DispatchGroup()
        var allReviews = [Review]()
        let now = Date()
        
        for collection in collections {
            let route = CollectionReviewsRoute(
                collectionName: collection.title,
                from: Calendar.current.date(byAdding: .day, value: -60, to: now)!,
                to: now)
            group.enter()
            ApiRequest(route: route, auth: auth).get {
                (response: ReviewsResponse?, _) in
                group.leave()
                if let reviews = response?.reviews {
                    allReviews.append(contentsOf: reviews)
                }
            }
        }
        
        group.notify(queue: .main) {
            self.apps = AppDelegate.provide.store.apps.reduce(into: [AppId: App](), { (result, pair) in
                let collectionApps = pair.value
                
                for app in collectionApps {
                    result[app.id] = app
                }
            })
            self.reviews = self.createReviewsSections(reviews: allReviews)
            self.sections = self.reviews.keys.sorted(by: { (lds, rds) -> Bool in
                lds.rawValue < rds.rawValue
            })
            complete();
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dateSection = sections[section]
        return reviews[dateSection]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        cell.selectedBackroundColor = .selectedItemBackground
        let dateSection = sections[indexPath.section]
        let review = reviews[dateSection]![indexPath.row]
        let app = apps[review.appId] ?? App.empty
        cell.bind(review: review, app: app)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[sections[section]]
    }
    
    // MARK: Private
    
    private func createReviewsSections(reviews: [Review]) -> [DateSection: [Review]] {
        var sections = [DateSection:[Review]]()

        let now = Date()
        let sorted = reviews.sorted(by: {
            if ($0.date != $1.date) {
                return $0.date > $1.date
            }
            if ($0.appId.value != $1.appId.value) {
                return $0.appId.value < $1.appId.value
            }
            if ($0.store != $1.store) {
                return $0.store < $1.store
            }
            return $0.rating.value > $1.rating.value
        })
        for review in sorted {
            let date = review.date
            let section = DateSection.for(date: date, today: now)
            if (sections[section] == nil) {
                sections[section] = [review]
            } else {
                sections[section]!.append(review)
            }
        }

        return sections
    }
    
}
