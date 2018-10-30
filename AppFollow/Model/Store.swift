//
//  Store.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation
import Snail

typealias CollectionApps = [CollectionId: [App]]
typealias Collections = [Collection]

struct NextOrError<T> {
    let next: T
    let error: Error?
    
    init(_ next: T) {
        self.init(next, nil)
    }
    
    init(_ next: T,_ error: Error?) {
        self.next = next
        self.error = error
    }
}

class Store {
    
    var collections: Collections = []
    var apps: CollectionApps = [:]
    
    let refreshed = Observable<NextOrError<Bool>>()
    
    func appFor(appId: AppId, collectionId: CollectionId) -> App {
        return apps[collectionId]?.first(where: { $0.id == appId }) ?? App.empty
    }

    func appFor(extId: ExtId, collectionId: CollectionId) -> App {
        return apps[collectionId]?.first(where: { $0.details.extId == extId }) ?? App.empty
    }
    
    func appsFor(extId: ExtId) -> [App] {
        var result = [App]()
        for pair in apps {
            for app in pair.value {
                if app.details.extId == extId {
                    result.append(app)
                }
            }
        }
        return result
    }
    
    func reset() {
        apps = [:]
        collections = []
    }
}
