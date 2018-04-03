//
//  AppViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 30/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import Cosmos

protocol AppSectionDataSourceDelegate: NSObjectProtocol {
    func dataSourceCompleteRefresh()
}

protocol AppSectionDataSource: UITableViewDataSource {
    var delegate: AppSectionDataSourceDelegate? { get set }
    func reload()
    func activate()
}

class AppViewController: UIViewController, AppSectionDataSourceDelegate {
    
    var app: App!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var stars: CosmosView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    lazy var auth = AppDelegate.provide.auth
    lazy var reviewsDataSource = AppReviewsDataSource(app: self.app, auth: self.auth)
    lazy var whatsNewDataSource = WhatsNewDataSource(app: self.app, auth: self.auth)
    lazy var overviewDataSource = OverviewDataSource(app: self.app)

    var currentSegment = 1
    
    var dataSourceForSegment: AppSectionDataSource {
        get {
            switch self.currentSegment {
                case 0: return self.overviewDataSource
                case 2: return self.whatsNewDataSource
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
        
        self.reviewsDataSource.delegate = self
        self.whatsNewDataSource.delegate = self
        self.overviewDataSource.delegate = self
        
        self.loadSummary()
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        self.tableView.dataSource = self.dataSourceForSegment
        self.dataSourceForSegment.activate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.refreshControl?.beginRefreshing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.refreshControl?.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let reviewViewController = segue.destination as? ReviewViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let review = self.reviewsDataSource.reviewFor(indexPath: indexPath)
                reviewViewController.reviewId = review.reviewId
                reviewViewController.app = self.app
            }
            
        }
    }
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        self.currentSegment = sender.selectedSegmentIndex
        self.tableView.dataSource = self.dataSourceForSegment
        self.tableView.reloadData()
        self.dataSourceForSegment.activate()
    }
    
    @objc func pullToRefresh() {
        self.reviewsDataSource.reload()
    }
    
    func loadSummary() {
        let auth = AppDelegate.provide.auth
        let parameters = ReviewsSummaryEndpoint.parameters(extId: self.app.extId, from: self.app.created, to: Date(), auth: auth)
        ApiRequest(url: ReviewsSummaryEndpoint.url, parameters: parameters).get {
            (response: ReviewsSummary?) in
            if let summary = response {
                self.stars.isHidden = false
                self.stars.rating = summary.ratingAverage
                self.stars.text = "(\(summary.ratingCount))"
            }
        }
    }
    
    // MARK: AppViewDataSourceDelegate
    
    func dataSourceCompleteRefresh() {
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
    }
}
