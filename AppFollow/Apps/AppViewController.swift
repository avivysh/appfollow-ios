//
//  AppViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 30/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import Cosmos

class AppViewController: UIViewController {
    
    var app: App!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var stars: CosmosView!
    @IBOutlet weak var tableView: UITableView!
    
    var reviewsDataSource: AppReviewsDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.appTitle.text = app.details.title
        self.publisher.text = app.details.publisher
        self.stars.text = "(\(app.reviewsCount))"
        self.stars.settings.updateOnTouch = false
        self.stars.settings.starMargin = 2
        IconLoader.into(self.icon, url: app.details.icon)
        
        let auth = AppDelegate.provide.auth
        self.reviewsDataSource = AppReviewsDataSource(app: self.app, auth: auth)
        self.tableView.dataSource = self.reviewsDataSource

        self.reviewsDataSource.reload {
            self.tableView.reloadData()
        }
    }
    
}
