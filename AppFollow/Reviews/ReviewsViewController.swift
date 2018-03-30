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
        
        self.tableView.dataSource = self.dataSource
        AppDelegate.provide.stateRefresh.refresh()
        self.tableView.dataSource = self.dataSource
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .collectionsUpdate, object: nil)
    }
    
    @objc func reloadTableView() {
        dataSource.reload {
            self.tableView.reloadData()
        }
    }
}
