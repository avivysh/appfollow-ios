//
//  AppsViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

class AppsViewController: UIViewController, AppsDataSourceDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: AppsDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let auth = AppDelegate.provide.authStorage.retrieve()
        self.dataSource = AppsDataSource(auth: auth)
        self.dataSource?.delegate = self
        self.tableView.dataSource = self.dataSource
        self.dataSource?.refresh()
    }
    
    // MARK: AppsDataSourceDelegate
    
    func reloadTableView() {
        self.tableView.reloadData()
    }

}
