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
    @IBOutlet weak var actionBarBottom: NSLayoutConstraint!
    
    lazy var dataSource = ReviewReplyDataSource(reviewId: self.reviewId, app: self.app, auth: AppDelegate.provide.auth)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self.dataSource
        self.dataSource.reload {
            self.tableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard
            let frameEnd = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect
        else {
            return
        }
        // TODO: Find a better way to pass safe area in a container in a tab bar
        let safeAreaBottom = self.parent?.parent?.view.safeAreaInsets.bottom ?? 0
        self.actionBarBottom.constant = frameEnd.height - safeAreaBottom
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.actionBarBottom.constant = 0
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        if let lastIndex = self.tableView.indexPathsForVisibleRows?.last {
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: lastIndex, at: .top, animated: true)
            }
        }
    }
}
