//
//  AppViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 30/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import Cosmos

protocol AppViewDataSource: UITableViewDataSource {
    func reload()
    var dataSourceRefreshComplete: () -> Void { get set }
    func dataSourceBecomeActive()
}

class AppViewController: UIViewController {
    
    var app: App!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var stars: CosmosView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var reviewsDataSource: AppReviewsDataSource!
    
    var currentSegment = 1
    
    var dataSourceForSegment: AppViewDataSource {
        get {
            switch self.currentSegment {
                case 0: return self.reviewsDataSource
                case 2: return self.reviewsDataSource
                default: return self.reviewsDataSource
            }
        }
    }
    
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
        self.reviewsDataSource.dataSourceRefreshComplete = {
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }

        self.loadSummary()
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        self.tableView.dataSource = self.dataSourceForSegment
        self.dataSourceForSegment.dataSourceBecomeActive()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.refreshControl?.beginRefreshing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.refreshControl?.endRefreshing()
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        self.currentSegment = sender.selectedSegmentIndex
        self.tableView.dataSource = self.dataSourceForSegment
        self.tableView.reloadData()
        self.dataSourceForSegment.dataSourceBecomeActive()
    }
    
    @objc func pullToRefresh() {
        self.reviewsDataSource.reload()
    }
    
    func loadSummary() {
        let auth = AppDelegate.provide.auth
        let parameters = ReviewsSummaryEndpoint.parameters(extId: self.app.extId, from: self.app.created, to: Date(), auth: auth)
        ApiRequest(url: ReviewsSummaryEndpoint.url, parameters: parameters).send {
            (response: ReviewsSummary?) in
            if let summary = response {
                self.stars.isHidden = false
                self.stars.rating = summary.ratingAverage
                self.stars.text = "(\(summary.ratingCount))"
            }
        }
    }
}
