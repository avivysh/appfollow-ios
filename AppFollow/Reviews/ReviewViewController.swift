//
//  ReviewViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 02/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import Snail

class ReviewViewController: UIViewController {
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
    @IBOutlet weak var integrationDisabled: UIView!
    
    var app: App!
    var reviewId: ReviewId!
    
    lazy var dataSource = ReviewReplyDataSource(reviewId: self.reviewId, app: self.app, auth: AppDelegate.provide.auth)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actionButton.isEnabled = false
        self.textField.isEditable = false
        self.tableView.dataSource = self.dataSource
        
        if (app.hasReplyIntegration.value) {
            self.integrationDisabled.isHidden = true
        } else {
            self.integrationDisabled.isHidden = false
            self.integrationDisabled.applyVibrancy(style: .light, blurAlpha: 0.65)
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
        NotificationCenter.default.observeEvent(.UIKeyboardDidShow).subscribe (
            onNext: { [weak self] _ in
                if let lastIndex = self?.tableView.indexPathsForVisibleRows?.last {
                    DispatchQueue.main.async {
                        self?.tableView.scrollToRow(at: lastIndex, at: .top, animated: true)
                    }
                }
            }
        )
        
        self.dataSource.refreshed.subscribe(
            onNext: { [weak self] _ in
                self?.reload()
            },
            onError: { [weak self] error in
                self?.tableView.makeToast("Error: \(error.localizedDescription)")
            }
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        IconRemote(url: app.details.icon).into(self.appTitle)

        self.dataSource.reload()
    }
    
    @IBAction func actionApp(_ sender: UIBarButtonItem) {
        let appViewController = AppViewController.instantiateFromStoryboard(app: self.app)
        self.navigationController?.pushViewController(appViewController, animated: true)
    }
    
    @IBAction func actionOpenIntegration(_ sender: UIButton) {
        self.present(url: URL(string: "https://help.appfollow.io/integrations")!)
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
}
