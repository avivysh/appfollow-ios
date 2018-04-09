//
//  ProfileViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import SwiftyBeaver

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descr: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var appVersion: UIButton!
    
    @IBAction func signOut(_ sender: UIButton) {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            AppDelegate.provide.store.apps = [:]
            AppDelegate.provide.store.collections = []
            AppDelegate.provide.store.reviewsSummary = [:]
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let fileDestination = log.destinations.filter { (destination) -> Bool in
                destination is FileDestination
            }.first as? FileDestination
            let _ = fileDestination?.deleteLogFile()
            appDelegate.window?.rootViewController = LoginViewController.instantiateFromStoryboard()
        }
    }
    
    @IBAction func versionMenu(_ sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "Developer options", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Send push", style: .default, handler: { _ in
            NSLog("Send push")
        }))
        alert.addAction(UIAlertAction(title: "Send logs", style: .default, handler: { _ in
            let fileDestinations = log.destinations.filter { (destination) -> Bool in destination is FileDestination }
            
            guard let fileDestination = fileDestinations.first as? FileDestination,
                  let logFileUrl = fileDestination.logFileURL
            else {
                return
            }
            let activity = UIActivityViewController(activityItems: [logFileUrl], applicationActivities: nil)
            self.present(activity, animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profile = AppDelegate.provide.profile
        self.name.text = profile.name
        self.descr.text = profile.description
        self.email.text = profile.email
        self.company.text = profile.company
        if (!profile.image.isEmpty) {
            self.image.af_setImage(withURL: URL(string: profile.image, relativeTo: URL(string: "https://watch.appfollow.io"))!)
        }
        
        let versionName = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let versionCode = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        self.appVersion.setTitle("AppFollow \(versionName) (\(versionCode))", for: .normal)
    }
}
