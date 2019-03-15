//
//  ReviewViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 02/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import Snail

class ReviewViewController: UIViewController, UITableViewDelegate, ShareDelegate {
    static func instantiateFromStoryboard(app: App, reviewId: ReviewId) -> ReviewViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
        controller.app = app
        controller.reviewId = reviewId
        return controller
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionBarBottom: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var appTitle: UIBarButtonItem!
    @IBOutlet weak var actionBar: UIView!
    @IBOutlet weak var loadingAnimation: UIActivityIndicatorView!
    
    var app: App!
    var reviewId: ReviewId!
    
    lazy var dataSource = ReviewReplyDataSource(reviewId: self.reviewId, app: self.app, auth: AppDelegate.provide.auth)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actionButton.isEnabled = false
        self.textField.isEditable = false
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
        
        if (app.hasReplyIntegration.value) {
            self.actionBar.isHidden = false
        } else {
            self.actionBar.isHidden = true
        }
        
        self.view.keyboardHeightWillChange.subscribe(
            onNext: { [weak self] (height, duration) in
                if height == 0 {
                    self?.actionBarBottom.constant = 0
                } else {
                    // TODO: Find a better way to pass safe area in a container in a tab bar
                    let safeAreaBottom = self?.parent?.parent?.view.safeAreaInsets.bottom ?? 0
                    self?.actionBarBottom.constant = height - safeAreaBottom
                }
            }
        )
        
        NotificationCenter.default.observeEvent(UIResponder.keyboardDidShowNotification).subscribe (
            onNext: { [weak self] _ in
                if let lastIndex = self?.tableView.indexPathsForVisibleRows?.last {
                    DispatchQueue.main.async {
                        self?.tableView.scrollToRow(at: lastIndex, at: .top, animated: true)
                    }
                }
            }
        )
        
        self.dataSource.shareDelegate = self
        self.dataSource.refreshed.subscribe(
            onNext: { [weak self] result in
                if let error = result.error {
                    self?.loadingAnimation.stopAnimating()
                    self?.tableView.makeToast("Error: \(error.localizedDescription)")
                } else {
                    self?.loadingAnimation.stopAnimating()
                    self?.reload()
                }
            }
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IconRemote(url: app.details.icon).into(self.appTitle)
        
        UIMenuController.shared.menuItems = [
            UIMenuItem(title: "Share", action: #selector(ReviewCell.shareFeedback(_:))),
            UIMenuItem(title: "Copy", action: #selector(ReviewCell.copyFeedback(_:))),
        ]
        
        self.dataSource.reload()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIMenuController.shared.menuItems = nil
    }
    
    @IBAction func actionApp(_ sender: UIBarButtonItem) {
        let appViewController = AppViewController.instantiateFromStoryboard(app: self.app)
        self.navigationController?.pushViewController(appViewController, animated: true)
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
                ApiRequest(route: ReplyRoute(extId: self.app.extId, reviewId: self.reviewId, answer: answerText, store: app.store), auth: AppDelegate.provide.auth).get {
                    (response: ReplyResponse?, error: Error?) in
                    if let replyResponse = response {
                        log.info(replyResponse)
                        let answer = ReviewAnswer(answered: true, date: Date().ymd, text: answerText)
                        self.textField.text = ""
                        self.dataSource.updateAnswer(answer: answer)
                    } else {
                        let errorMessage = error?.localizedDescription
                        self.tableView.makeToast(errorMessage ?? "Error occured")
                    }
                    self.actionButton.isEnabled = true
                }
            }
        }
    }
    
    private func reload() {
        self.actionButton.isEnabled = true
        self.textField.isEditable = true
        self.tableView.reloadData()
        if let lastIndex = self.dataSource.lastIndex {
            self.tableView.scrollToRow(at: lastIndex, at: .top, animated: true)
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return self.dataSource.shouldShowMenuForRowAt(indexPath)
    }
    
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool
    {
        if (action == #selector(ReviewCell.shareFeedback(_:)) || action == #selector(ReviewCell.copyFeedback(_:)))
        {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?)
    {
        // Protocol function declaration is required to show menu item
        // thus, provided intentionally an empty method
    }
    
    // MARK: ShareDelegate
    
    func share(text: String) {
        let items = [
            text
        ]
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(vc, animated: true, completion: nil)
    }
}
