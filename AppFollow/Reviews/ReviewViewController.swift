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
    @IBOutlet weak var actionBarBottom: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var actionButton: UIButton!

    var app: App!
    var reviewId: ReviewId!
    
    lazy var dataSource = ReviewReplyDataSource(reviewId: self.reviewId, app: self.app, auth: AppDelegate.provide.auth)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actionButton.isEnabled = false
        self.textField.isEditable = false
        self.tableView.dataSource = self.dataSource
        self.dataSource.reload {
            review in
            self.actionButton.isEnabled = true
            self.textField.isEditable = true
            self.tableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func actionButtonPresssed(_ sender: UIButton) {
        if sender.tag == 8 {
            self.actionButton.setTitle("Send", for: .normal)
            self.actionButton.tag = 0
            self.textField.isEditable = true
            self.textField.becomeFirstResponder()
        } else {
            let answerText = self.textField.text ?? ""
            if !answerText.isEmpty {
                self.actionButton.isEnabled = false
                ApiRequest(route: ReplyRoute(extId: self.app.extId, reviewId: self.reviewId, answer: answerText), auth: AppDelegate.provide.auth).get { (response: ReplyResponse?, error: Error?) in
                    if let replyResponse = response {
                        log.info(replyResponse)
                        let answer = ReviewAnswer(answered: true, date: Date().ymd(), text: answerText)
                        self.textField.text = ""
                        self.dataSource.updateAnswer(answer: answer) {
                            self.tableView.reloadData()
                        }
                    } else {
                        let errorMessage = error?.localizedDescription
                        self.tableView.makeToast(errorMessage ?? "Error occured")
                    }
                    self.actionButton.isEnabled = true
                }
            }
        }
    }
    
    
    // MARK: Keybaord
    
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
