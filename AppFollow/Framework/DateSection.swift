//
//  Date.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 30/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

enum DateSection: Int {
    case today = 0
    case yesterday
    case thisWeek
    case thisMonth
    case older
    
    static func forDate(_ date: Date, today: Date) -> DateSection {
        
        if (Calendar.current.isDate(date, inSameDayAs: today))
        {
            return .today
        }

        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        if (date.compare(yesterdayDate) == ComparisonResult.orderedDescending)
        {
            return .yesterday
        }

        let thisWeekDate = Calendar.current.date(byAdding: .day, value: -7, to: today)!
        if (date.compare(thisWeekDate) == ComparisonResult.orderedDescending)
        {
            return .thisWeek
        }
        
        let thisMonthDate = Calendar.current.date(byAdding: .day, value: -30, to: today)!
        if (date.compare(thisMonthDate) == ComparisonResult.orderedDescending)
        {
            return .thisMonth
        }
        
        return .older
    }
}
