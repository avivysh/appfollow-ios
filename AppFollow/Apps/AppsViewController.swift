//
//  AppsViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

class AppsViewController: UIViewController {
    static func instantiateFromStoryboard() -> AppsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AppsViewController") as! AppsViewController
        return controller
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    let dataSource = AppsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource.updateState()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let appViewController = segue.destination as? AppViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                appViewController.app = self.dataSource.appFor(indexPath: indexPath)
            }
        }
    }
    
    // MARK: NotificationCenter
    
    @objc func reloadTableView(notification: NSNotification) {
        self.dataSource.updateState()
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
    }
    
    @objc func pullToRefresh() {
        self.tableView.refreshControl?.beginRefreshing()
        AppDelegate.provide.stateRefresh.refresh()
    }

}
