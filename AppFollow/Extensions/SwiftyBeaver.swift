//
//  SwiftyBeaver.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 13/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation
import SwiftyBeaver

extension SwiftyBeaver {
    
    static var fileDestinations: Set<FileDestination> {
        get {
            return SwiftyBeaver.self.destinations.filter { (destination) -> Bool in
                destination is FileDestination
            } as? Set<FileDestination> ?? Set<FileDestination>()
        }
    }

}
