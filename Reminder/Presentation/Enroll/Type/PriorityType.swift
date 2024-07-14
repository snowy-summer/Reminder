//
//  PriorityType.swift
//  Reminder
//
//  Created by 최승범 on 7/3/24.
//

import Foundation

enum PriorityType: Int, CaseIterable {
    case no
    case low
    case middle
    case high
    
    var title: String {
        switch self {
        case .no:
            return "없음"
        case .low:
            return "낮음"
        case .middle:
            return "중간"
        case .high:
            return "높음"
        }
    }
    
    var listTitle: String {
        switch self {
        case .no:
            return ""
        case .low:
            return "!"
        case .middle:
            return "!!"
        case .high:
            return "!!!"
        }
    }
}
