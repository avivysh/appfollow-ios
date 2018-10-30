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
    @IBOutlet weak var filterButton: UIBarButtonItem!
    let dataSource = ReviewsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.controlEvent(.valueChanged).subscribe(
            onNext: { _ in AppDelegate.provide.stateRefresh.refresh() }
        )
        
        AppDelegate.provide.push.registerForRemoteNotifications()
        
        self.filterButton.isEnabled = false
        AppDelegate.provide.store.refreshed.subscribe(
             onNext: { [weak self] result in
                if (result.next) {
                    self?.filterButton.isEnabled = true
                }
            }
        )
        
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
        
        self.dataSource.filteredCollection.subscribe(
            onNext: { [weak self] collection in
                if (collection == nil) {
                    self?.title = "Reviews"
                } else {
                    self?.title = "Reviews - \(collection!.title)"
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
    
    @IBAction func actionFilter(_ sender: UIBarButtonItem) {
        let filter = UIAlertController(title: "Choose collection", message: nil, preferredStyle: .actionSheet)
        filter.addAction(UIAlertAction(title: "None", style: .default, handler: { _ in
            self.dataSource.filter(collection: nil)
        }))
        AppDelegate.provide.store.collections.forEach { collection in
            filter.addAction(UIAlertAction(title: collection.title, style: .default, handler: { _ in
                self.dataSource.filter(collection: collection)
            }))
        }
        
        self.present(filter, animated: true, completion: nil)
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
