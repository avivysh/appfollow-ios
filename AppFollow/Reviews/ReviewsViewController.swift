//
//  ReviewsViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import Alamofire

class ReviewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let dataSource = ReviewsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDelegate.provide.stateRefresh.refresh()
        self.tableView.dataSource = self.dataSource
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .collectionsUpdate, object: nil)
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AppDelegate.provide.stateRefresh.isRefreshing {
            self.tableView.refreshControl?.beginRefreshing()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.refreshControl?.endRefreshing()
    }
    
    @objc func reloadTableView() {
        dataSource.reload {
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc func pullToRefresh() {
        AppDelegate.provide.stateRefresh.refresh()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let reviewViewController = segue.destination as? ReviewViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let review = self.dataSource.reviewFor(indexPath: indexPath)
                reviewViewController.reviewId = review.reviewId
                reviewViewController.app = self.dataSource.appFor(review: review)
            }
        }
    }
}
