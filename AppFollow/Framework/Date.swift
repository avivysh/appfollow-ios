//
//  Date.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 30/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

extension Date {
    static func byAdding(_ component: Calendar.Component, value: Int, date: Date) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: date)!
    }
}

extension DateFormatter {
    static func create(format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter
    }
}

