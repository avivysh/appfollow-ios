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

    @IBOutlet weak var loadingAnimation: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    let dataSource = ReviewsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDelegate.provide.stateRefresh.refresh()
        self.tableView.dataSource = self.dataSource
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.controlEvent(.valueChanged).subscribe(
            onNext: { _ in AppDelegate.provide.stateRefresh.refresh() }
        )
        
        AppDelegate.provide.push.registerForRemoteNotifications()
        
        self.dataSource.refreshed.subscribe(
            onNext: { [weak self] result in
                if let error = result.error {
                    self?.tableView.refreshControl?.endRefreshing()
                    self?.loadingAnimation.stopAnimating()
                    self?.view.makeToast("Error: \(error.localizedDescription)")
                } else {
                    self?.tableView.reloadData()
                    self?.tableView.refreshControl?.endRefreshing()
                    self?.loadingAnimation.stopAnimating()
                }
            }
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AppDelegate.provide.stateRefresh.isRefreshing {
            self.loadingAnimation.startAnimating()
            self.tableView.refreshControl?.beginRefreshing()
        } else {
            self.loadingAnimation.stopAnimating()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tableView.refreshControl?.endRefreshing()
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
