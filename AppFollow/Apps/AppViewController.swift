//
//  AppViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 30/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

class AppViewController: UIViewController {
    
    var app: App!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var publisher: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.appTitle.text = app.details.title
        self.publisher.text = app.details.publisher
        
        IconLoader.into(self.icon, url: app.details.icon)
    }
    
}
