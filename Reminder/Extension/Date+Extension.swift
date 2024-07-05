//
//  Date+Extension.swift
//  Reminder
//
//  Created by 최승범 on 7/5/24.
//

import Foundation

extension Date {
    func isSameDay(as otherDate: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: self)
        let components2 = calendar.dateComponents([.year, .month, .day], from: otherDate)
        return components1.year == components2.year &&
               components1.month == components2.month &&
               components1.day == components2.day
    }
}
