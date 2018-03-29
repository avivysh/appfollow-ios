//
//  AppsDataSource.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import Alamofire


class AppsDataSource: NSObject, UITableViewDataSource {
    
    private var collections: [Collection] = []
    private var apps: [Int: [App]] = [:]
    private var reviewsSummary: [ExtId: ReviewsSummary] = [:]

    // MARK: Public

    func updateState() {
        let store = AppDelegate.provide.store
        self.collections = store.collections
        self.apps = store.apps
        self.reviewsSummary = store.reviewsSummary
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let collection = self.collections[section]
        return apps[collection.id]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppCell", for: indexPath) as! AppCell
        let collection = self.collections[indexPath.section]
        cell.bind(app: apps[collection.id]![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return collections[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return collections.count
    }

}
