//
//  AppsDataSource.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import Alamofire
import Snail

class AppsDataSource: NSObject, UITableViewDataSource {
    
    private var collections: [Collection] = []
    private var apps: [CollectionId: [App]] = [:]

    var filter = ""
    let refreshed = Observable<NextOrError<Bool>>()
    
    override init() {
        super.init()
        
        self.update()
        
        AppDelegate.provide.store.refreshed.subscribe(
            onNext: { [weak self] result in
                self?.update()
                self?.refreshed.on(.next(result))
            }
        )
    }
    
    // MARK: Public
    
    func reload() {
        self.update()
        self.refreshed.on(.next(NextOrError(true)))
    }
    
    func appFor(indexPath: IndexPath) -> App {
        let collection = self.collections[indexPath.section]
        return apps[collection.id]![indexPath.row]
    }

    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let collection = self.collections[section]
        return apps[collection.id]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppCell", for: indexPath) as! AppCell
        cell.bind(app: self.appFor(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return collections[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return collections.count
    }
    
    // MARK: Private
    
    private func update() {
        let store = AppDelegate.provide.store
        
        if (self.filter.isEmpty) {
            self.collections = store.collections
            self.apps = store.apps
        } else {
            var filteredCollections = [Collection]()
            var filteredApps = [CollectionId: [App]]()
            let lowercasedFilter = self.filter.lowercased()
            store.collections.forEach({ collection in
                let storeApps = store.apps[collection.id] ?? [App]()
                let apps = storeApps.filter({ $0.details.title.lowercased().range(of: lowercasedFilter) != nil })
                if (!apps.isEmpty) {
                    filteredCollections.append(collection)
                    filteredApps[collection.id] = apps
                }
            })
            self.collections = filteredCollections
            self.apps = filteredApps
        }
    }
}
