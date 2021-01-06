//
//  Date+StockApp.swift
//  StockApp
//
//  Created by Kenichi Fujita on 1/6/21.
//

import Foundation

extension Date {
    static func mostRecentWeekdayDate(hour: Int, minute: Int) -> Date? {
        let today = Date()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: today)
        var dateAdjustment = -1
        if weekday == 1 {
            dateAdjustment -= 2
        } else if weekday == 7 {
            dateAdjustment -= 1
        }
        var components = calendar.dateComponents([.year, .month, .day], from: today)
        components.timeZone = TimeZone(abbreviation: "EST")
        components.day = components.day?.advanced(by: dateAdjustment)
        components.hour = hour
        components.minute = minute
        return calendar.date(from: components)
    }
}
