//
//  TabViewController.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 03/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

class TabViewController: UIViewController {

    weak var embedController: UIViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedSegue" {
            self.embedController = segue.destination
        }
    }
}
