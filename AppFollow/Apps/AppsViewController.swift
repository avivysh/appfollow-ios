//
//  AppsViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import Snail

class AppsViewController: UIViewController, UITableViewDelegate {
    static func instantiateFromStoryboard() -> AppsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AppsViewController") as! AppsViewController
        return controller
    }
    
    @IBOutlet weak var loadingAnimation: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    let dataSource = AppsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDelegate.provide.stateRefresh.refresh()
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
            
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
            onNext: { [weak self] result in
                if let error = result.error {
                    self?.tableView.refreshControl?.endRefreshing()
                    self?.loadingAnimation.stopAnimating()
                    self?.view.makeToast("Error: \(error.localizedDescription)")
                } else {
                    self?.tableView.reloadData()
                    self?.tableView.refreshControl?.endRefreshing()
                    self?.loadingAnimation.stopAnimating()
                }
            }
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selected, animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AppDelegate.provide.stateRefresh.isRefreshing {
            self.loadingAnimation.startAnimating()
            self.tableView.refreshControl?.beginRefreshing()
        } else {
            self.loadingAnimation.stopAnimating()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tableView.refreshControl?.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let appViewController = segue.destination as? AppViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                appViewController.app = self.dataSource.appFor(indexPath: indexPath)
            }
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.coal
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.ash
    }

}
