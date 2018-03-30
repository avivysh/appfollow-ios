//
//  AppsViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

class AppsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let dataSource = AppsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource.updateState()
        AppDelegate.provide.stateRefresh.refresh()
        self.tableView.dataSource = self.dataSource
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .collectionsUpdate, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    }

}
