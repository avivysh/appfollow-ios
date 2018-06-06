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
    
    func appFor(appId: AppId) -> App {
        for pair in apps {
            for app in pair.value {
                if app.id == appId {
                    return app
                }
            }
        }
        return App.empty
    }

    func appFor(extId: ExtId) -> App {
        for pair in apps {
            for app in pair.value {
                if app.details.extId == extId {
                    return app
                }
            }
        }
        return App.empty
    }
    
    func reset() {
        apps = [:]
        collections = []
    }
}
