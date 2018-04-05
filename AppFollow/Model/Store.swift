//
//  Store.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let collectionsUpdate = Notification.Name("collectionsUpdate")
}

class Store {
    
    var collections: [Collection] = []
    var apps: [CollectionId: [App]] = [:]
    var reviewsSummary: [ExtId : ReviewsSummary] = [:]

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
}
