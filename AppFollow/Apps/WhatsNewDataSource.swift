//
//  WhatsNewDataSource.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 02/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import Snail

class WhatsNewDataSource: NSObject, AppSectionDataSource {
    let refreshed = Observable<Bool>()
    
    private var whatsnew: [WhatsNew] = []
    private let app: App
    private let auth: AuthProvider
    private var loaded = false
    
    init(app: App, auth: AuthProvider) {
        self.app = app
        self.auth = auth
        super.init()
        
        self.refreshed.subscribe(onNext: { _ in self.loaded = true })
    }
    
    func reload() {
        ApiRequest(route: WhatsNewRoute(extId: app.extId, store: app.store), auth: self.auth).get {
            (response: WhatsNewResponse?, _) in
            if let whatsnew = response?.whatsnew.list {
                self.whatsnew = whatsnew
            }
            self.refreshed.on(.next(true))
        }
    }
    
    func activate() {
        if (self.loaded) {
            self.refreshed.on(.next(true))
            return
        }
        
        self.reload()
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.whatsnew.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WhatsNewCell", for: indexPath) as! WhatsNewCell
        let whatsnew = self.whatsnew[indexPath.row]
        cell.bind(whatsnew: whatsnew)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "What's new"
    }
}
