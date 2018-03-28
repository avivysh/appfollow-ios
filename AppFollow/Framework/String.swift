//
//  String.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation


extension String {
    func escapeJavaScript() -> String {
        var output = self.replacingOccurrences(of: "\\", with: "\\\\")
        output = output.replacingOccurrences(of: "\"", with: "\\\"")
        output = output.replacingOccurrences(of: "'", with: "\\'")
        return output.replacingOccurrences(of: "/", with: "\\/")
    }
}
