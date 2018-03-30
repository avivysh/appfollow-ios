//
//  StateRefresh.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation


class StateRefresh {
    var store: Store
    let auth: Auth
    
    init(store: Store, auth: Auth) {
        self.store = store
        self.auth = auth
    }
    
    func refresh() {
        self.requestCollections() {
            collections in
            
            var allApps = [Int: [App]]()

            let group = DispatchGroup()
            for collection in collections {
                group.enter()
                self.requestApps(collectionId: collection.id) { apps in
                    group.leave()
                    allApps[collection.id] = apps
                }
            }
            
            group.notify(queue: .main) {
                self.store.collections = collections
                self.store.apps = allApps
                NotificationCenter.default.post(name: .collectionsUpdate, object: self)
            }
        }
    }
    
    
    // MARK: Private
    
    private func requestApps(collectionId: Int, completion: @escaping ([App]) -> Void) {
        ApiRequest(url: AppEndpoint.url, parameters: AppEndpoint.parameters(collectionId: collectionId, auth: self.auth)).send {
            (response: CollectionResponse?) in
            if let collection = response {
                completion(collection.apps)
            } else {
                completion([])
            }
        }
    }
    
    private func requestCollections(completion: @escaping ([Collection]) -> Void) {
        ApiRequest(url: AppsEndpoint.url, parameters: AppsEndpoint.parameters(auth: self.auth)).send {
            (response: CollectionsResponse?) in
            if let collections = response {
                completion(collections.collections)
            } else {
                completion([])
            }
        }
    }
    
    private func refreshReviewsSummary(app: App, completion: @escaping (ReviewsSummary?) -> Void) {
        let parameters = ReviewsSummaryEndpoint.parameters(extId: app.extId, auth: self.auth)
        ApiRequest(url: ReviewsSummaryEndpoint.url, parameters: parameters).send(completion: completion)
    }
}
