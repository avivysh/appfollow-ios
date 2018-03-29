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
        let parameters = AppEndpoint.parameters(collectionId: collectionId, auth: auth)
        let request = Alamofire.request(AppEndpoint.url, parameters: parameters).responseData {
            response in
            if let data = response.result.value {
                let decoder = JSONDecoder()
                do {
                    let collectionResponse = try decoder.decode(CollectionResponse.self, from: data)
                    completion(collectionResponse.apps)
                } catch {
                    print(error)
                    completion([])
                }
            }
        }
        debugPrint(request)
    }
    
    private func requestCollections(auth: Auth, completion: @escaping ([Collection]) -> Void) {
        let parameters = AppsEndpoint.parameters(auth: auth)
        let request = Alamofire.request(AppsEndpoint.url, parameters: parameters).responseData {
            response in
            if let data = response.result.value {
                let decoder = JSONDecoder()
                do {
                    let collectionsResponse = try decoder.decode(CollectionsResponse.self, from: data)
                    completion(collectionsResponse.collections)
                } catch {
                    print(error)
                    completion([])
                }
            }
        }
        debugPrint(request)
    }
}
