//
//  Date.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 30/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation


private let ymdFormatter = DateFormatter.create(format: "yyyy-MM-dd")
private let ymdhmsFomrmatter = DateFormatter.create(format: "yyyy-MM-dd HH:mm:ss")

extension Date {
    static let unknown = Date(timeIntervalSince1970: 0)
    
    var isValid: Bool {
        get { return self != Date.unknown }
    }
    
    static func byAdding(_ component: Calendar.Component, value: Int, date: Date) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: date)!
    }

    func ymd() -> String {
        return ymdFormatter.string(from: self)
    }
}

extension DateFormatter {
    static func create(format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter
    }

    static func date(ymdhms: String) -> Date {
        if ymdhms.isEmpty {
            return Date.unknown
        }
        return ymdhmsFomrmatter.date(from: ymdhms) ?? Date.unknown
    }
}

