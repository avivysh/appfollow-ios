//
//  AppsDataSource.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import Alamofire

protocol AppsDataSourceDelegate: NSObjectProtocol {
    func reloadTableView()
}

class AppsDataSource: NSObject, UITableViewDataSource {
    
    weak var delegate: AppsDataSourceDelegate?
    
    private let auth: Auth
    private var collections: [Collection] = []
    private var apps: [Int: [App]] = [:]

    init(auth: Auth) {
        self.auth = auth
    }
    
    // MARK: Public
    
    func refresh() {
        self.requestCollections(auth: auth) {
            collections in
            
            self.collections = collections
            let group = DispatchGroup()
            for (index, collection) in collections.enumerated() {
                group.enter()
                self.requestApps(collectionId: collection.id, auth: self.auth) {
                    apps in
                    group.leave()
                    self.apps[index] = apps
                }
            }
            
            group.notify(queue: .main) {
                self.delegate?.reloadTableView()
            }
            
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apps[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppCell", for: indexPath) as! AppCell
        cell.bind(app: apps[indexPath.section]![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return collections[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return collections.count
    }

    // MARK: Private
    
    private func requestApps(collectionId: Int, auth: Auth, completion: @escaping ([App]) -> Void) {
        ApiRequest(url: AppEndpoint.url, parameters: AppEndpoint.parameters(collectionId: collectionId, auth: auth)).send {
            (response: CollectionResponse?) in
            if let collection = response {
                completion(collection.apps)
            } else {
                completion([])
            }
        }
    }
    
    private func requestCollections(auth: Auth, completion: @escaping ([Collection]) -> Void) {
        ApiRequest(url: AppsEndpoint.url, parameters: AppsEndpoint.parameters(auth: auth)).send {
            (response: CollectionsResponse?) in
            if let collections = response {
                completion(collections.collections)
            } else {
                completion([])
            }
        }
    }
}
