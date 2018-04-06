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
    let auth: AuthProvider
    var isRefreshing = false

    init(store: Store, auth: AuthProvider) {
        self.store = store
        self.auth = auth
    }
    
    func refresh() {
        self.isRefreshing = true
        self.requestCollections() {
            collections in
            
            var allApps = [CollectionId: [App]]()

            let group = DispatchGroup()
            for collection in collections {
                group.enter()
                self.requestApps(collectionId: collection.id) { apps in
                    group.leave()
                    allApps[collection.id] = apps
                }
            }
            
            group.notify(queue: .main) {
                self.isRefreshing = false
                self.store.collections = collections
                self.store.apps = allApps
                NotificationCenter.default.post(name: .collectionsUpdate, object: self)
            }
        }
    }
    
    
    // MARK: Private
    
    private func requestApps(collectionId: CollectionId, completion: @escaping ([App]) -> Void) {
        ApiRequest(route: AppRoute(collectionId: collectionId), auth: self.auth).get {
            (response: CollectionResponse?, _) in
            if let collection = response {
                completion(collection.apps)
            } else {
                completion([])
            }
        }
    }
    
    private func requestCollections(completion: @escaping ([Collection]) -> Void) {
        ApiRequest(route: AppsRoute(), auth: self.auth).get {
            (response: CollectionsResponse?, _) in
            if let collections = response {
                completion(collections.collections)
            } else {
                completion([])
            }
        }
    }
}
