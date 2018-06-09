//
//  App.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 09/06/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation


enum FontAwesome: String {
    case none = ""
    case android = "\u{f17b}"
    case mac = "\u{f170}"
    case windows = "\u{f17a}"
    case apple = "\u{f179}"
    case amazon = "\u{f270}"
}

extension App {
    
    var nameForStore: String {
        switch store {
        case "googleplay": return "Google Play"
        case "itunes": return "App Store"
        case "microsoftstore": return "Windows Store"
        case "amazon": return "Amazon"
        case "macstore": return "Mac App Store"
        default:
            return store.localizedUppercase
        }
    }
    
    var charForStore: FontAwesome {
        switch store {
            case "googleplay": return .android
            case "itunes": return .apple
            case "microsoftstore": return .windows
            case "amazon": return .amazon
            case "macstore": return .mac
            default:
                return .none
        }
    }
}
