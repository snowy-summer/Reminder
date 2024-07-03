//
//  DateManager.swift
//  Reminder
//
//  Created by 최승범 on 7/3/24.
//

import Foundation

final class DateManager {
    
    static let shared = DateManager()
    private let dateformatter = DateFormatter()
    
    private init() { }
    
    func formattedDate(date: Date) -> String {
        dateformatter.dateFormat = "yyyy.MM.dd"
        
        return dateformatter.string(from: date)
    }
}
