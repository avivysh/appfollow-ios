//
//  ReviewViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 02/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var send: UIButton!
    
    var app: App!
    var reviewId: ReviewId!
    
    lazy var dataSource = ReviewReplyDataSource(reviewId: self.reviewId, app: self.app, auth: AppDelegate.provide.auth)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self.dataSource
        self.dataSource.reload {
            self.tableView.reloadData()
        }
    }
    
}
