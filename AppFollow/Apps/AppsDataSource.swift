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
    
}

class AppsDataSource: UITableViewDataSource {
    
    weak var delegate: AppsDataSourceDelegate?
    
    private let auth: Auth
    private var collections: [Collection] = []
    private var apps: [Int: [App]] = [:]

    init(auth: Auth) {
        self.auth = auth
    }
    
    func refresh() {
        self.requestCollections(auth: auth) {
            collections in
            
            let group = DispatchGroup()
            for collection in collections {
                group.enter()
                self.requestApps(collectionId: collection.id, auth: self.auth) {
                    apps in
                    group.leave()
                    self.apps[collection.id] = apps
                }
            }
            
            group.notify(queue: .main) {
                print("all requests done")
            }
            
        }
    }
    
    
    private func requestApps(collectionId: Int, auth: Auth, completion: @escaping ([App]) -> Void) {
        let parameters = AppEndpoint.parameters(collectionId: collectionId, auth: auth)
        Alamofire.request(AppEndpoint.url, parameters: parameters).responseData {
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
    }
    
    private func requestCollections(auth: Auth, completion: @escaping ([Collection]) -> Void) {
        let parameters = AppsEndpoint.parameters(auth: auth)
        Alamofire.request(AppsEndpoint.url, parameters: parameters).responseData {
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
    }
}
