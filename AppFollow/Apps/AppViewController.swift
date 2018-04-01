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

        self.stars.isHidden = true
        self.stars.settings.updateOnTouch = false
        self.stars.settings.starMargin = 2
        IconLoader.into(self.icon, url: app.details.icon)
        
        let auth = AppDelegate.provide.auth
        self.reviewsDataSource = AppReviewsDataSource(app: self.app, auth: auth)
        self.tableView.dataSource = self.reviewsDataSource

        self.reviewsDataSource.reload {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
        
        let parameters = ReviewsSummaryEndpoint.parameters(extId: self.app.extId, from: self.app.created, to: Date(), auth: auth)
        ApiRequest(url: ReviewsSummaryEndpoint.url, parameters: parameters).send {
            (response: ReviewsSummary?) in
            if let summary = response {
                self.stars.isHidden = false
                self.stars.rating = summary.ratingAverage
                self.stars.text = "(\(summary.ratingCount))"
            }
        }
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.refreshControl?.beginRefreshing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.refreshControl?.endRefreshing()
    }
    
    @objc func pullToRefresh() {
        self.reviewsDataSource.reload {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
}
