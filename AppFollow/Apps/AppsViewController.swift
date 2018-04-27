//
//  AppsViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import Snail

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
        
        AppDelegate.provide.stateRefresh.refresh()
        self.tableView.dataSource = self.dataSource
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.controlEvent(.valueChanged).subscribe(
            onNext: { _ in
                self.tableView.refreshControl?.beginRefreshing()
                AppDelegate.provide.stateRefresh.refresh()
            }
        )
        self.dataSource.refreshed.subscribe(
            onNext: { [weak self] _ in
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            }
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AppDelegate.provide.stateRefresh.isRefreshing {
            self.tableView.refreshControl?.beginRefreshing()
        } else {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let appViewController = segue.destination as? AppViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                appViewController.app = self.dataSource.appFor(indexPath: indexPath)
            }
        }
    }

}
