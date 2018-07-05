//
//  ReviewsViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import Alamofire

class ReviewsViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var loadingAnimation: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    let dataSource = ReviewsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDelegate.provide.stateRefresh.refresh()
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.controlEvent(.valueChanged).subscribe(
            onNext: { _ in AppDelegate.provide.stateRefresh.refresh() }
        )
        
        let titleImageView = UIImageView()
        titleImageView.image = UIImage(named: "logo-white")
        titleImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleImageView
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selected, animated: false)
        }
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.coal
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.ash
    }
}
