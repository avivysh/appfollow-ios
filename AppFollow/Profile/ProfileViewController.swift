//
//  ProfileViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit
import Intercom

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
            AppDelegate.provide.store.reset()
            Intercom.logout()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let _ = log.fileDestinations.first?.deleteLogFile()
            appDelegate.window?.rootViewController = LoginViewController.instantiateFromStoryboard()
        }
    }
    
    @IBAction func versionMenu(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Developer options", message: nil, preferredStyle: .actionSheet)
        alert.addAction(PushTestAction(view: self.view))
        alert.addAction(LocalNotificationAction(view: self.view))
        alert.addAction(SendLogsAction(viewController: self))
        alert.addAction(UIAlertAction.cancel)
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = self.appVersion.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profile = AppDelegate.provide.profile
        self.name.text = profile.name
        self.descr.text = profile.description
        self.email.text = AppDelegate.provide.auth.actual.email
        self.company.text = profile.company
        if let imageURL = URL(string: profile.image), !profile.image.isEmpty {
            self.image.af_setImage(withURL: imageURL)
        }
        
        let versionName = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let versionCode = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        self.appVersion.setTitle("AppFollow \(versionName) (\(versionCode))", for: .normal)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Intercom.setBottomPadding(80)
        Intercom.setLauncherVisible(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Intercom.setLauncherVisible(false)
        super.viewWillDisappear(animated)
    }
}
