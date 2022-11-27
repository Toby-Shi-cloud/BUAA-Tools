//
//  SimpleDate.swift
//  BUAA Tools
//
//  Created by mac on 2022/11/27.
//

import Foundation

struct SimpleDate: Equatable, Hashable {
    let year: Int
    let month: Int
    let day: Int
    var dateComponents: DateComponents {
        DateComponents(calendar: Calendar.current, year: year, month: month, day: day)
    }
    
    init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
    
    init(from date: Date) {
        let calendar = Calendar.current
        self.year = calendar.component(.year, from: date)
        self.month = calendar.component(.month, from: date)
        self.day = calendar.component(.day, from: date)
    }
    
    func toDate() -> Date {
        let calendar = Calendar.current
        return calendar.date(from: dateComponents)!
    }
    
    static func - (lhs: SimpleDate, rhs: SimpleDate) -> Int {
        let calendar = Calendar.current
        let d1 = calendar.date(from: lhs.dateComponents)!
        let d2 = calendar.date(from: rhs.dateComponents)!
        let interval = DateInterval(start: d2, end: d1).duration
        return Int(interval / 24 / 3600 + 0.00001)
    }
    
    static func + (lhs: SimpleDate, rhs: Int) -> SimpleDate {
        let calendar = Calendar.current
        let d1 = calendar.date(from: lhs.dateComponents)!
        return SimpleDate(from: d1 + TimeInterval((rhs * 24 * 3600)))
    }
}
