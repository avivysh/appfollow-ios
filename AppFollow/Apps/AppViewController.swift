//
//  AppViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 30/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import Cosmos
import Snail

protocol AppSectionDataSource: UITableViewDataSource {
    var refreshed: Observable<NextOrError<Bool>> { get }
    func reload()
    func activate()
    func didSelectRowAt(indexPath: IndexPath)
}

class AppViewController: UIViewController, UITableViewDelegate {

    static func instantiateFromStoryboard(app: App) -> AppViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AppViewController") as! AppViewController
        controller.app = app
        return controller
    }
    
    var app: App!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var stars: CosmosView!
    @IBOutlet weak var tableView: UITableView!
    
    var auth: AuthProvider { return AppDelegate.provide.auth }
    lazy var reviewsDataSource = AppReviewsDataSource(app: self.app, auth: self.auth)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.appTitle.text = app.details.title
        self.publisher.text = app.details.publisher

        let titleImageView = UIImageView()
        titleImageView.image = UIImage(named: "logo-white")
        titleImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleImageView
        
        self.stars.isHidden = true
        self.stars.settings.updateOnTouch = false
        self.stars.settings.starMargin = 2
        IconRemote(url: app.details.icon).into(self.icon)
        
        self.reviewsDataSource.refreshed.subscribe( onNext: { [weak self] _ in
            self?.reload()
        })

        self.loadSummary()
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.controlEvent(.valueChanged).subscribe(
            onNext: { _ in
                self.reviewsDataSource.reload()
            }
        )
        
        self.tableView.delegate = self
        self.tableView.dataSource = self.reviewsDataSource
        self.reviewsDataSource.activate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.refreshControl?.beginRefreshing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.refreshControl?.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let reviewViewController = segue.destination as? ReviewViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let review = self.reviewsDataSource.reviewFor(indexPath: indexPath)
                reviewViewController.reviewId = review.reviewId
                reviewViewController.app = self.app
            }
        }
    }

    private func loadSummary() {
        let auth = AppDelegate.provide.auth
        ApiRequest(route: ReviewsSummaryRoute(extId: self.app.extId, from: self.app.created, to: Date(), store: app.store), auth: auth).get {
            (response: ReviewsSummary?, _) in
            if let summary = response {
                self.stars.isHidden = false
                self.stars.rating = summary.ratingAverage
                self.stars.text = "(\(summary.ratingCount))"
            }
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.reviewsDataSource.didSelectRowAt(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.coal
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.ash
    }
    
    // MARK: Private
    
    private func reload() {
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
    }
}
