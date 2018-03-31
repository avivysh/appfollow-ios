//
//  ProfileViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descr: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    @IBAction func signOut(_ sender: UIButton) {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = LoginViewController.instantiateFromStoryboard()
        }
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
    }
}
