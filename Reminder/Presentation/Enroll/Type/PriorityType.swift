//
//  PriorityType.swift
//  Reminder
//
//  Created by 최승범 on 7/3/24.
//

import Foundation

enum PriorityType: Int, CaseIterable {
    case high
    case middle
    case low
    
    var title: String {
        switch self {
        case .high:
            return "상"
        case .middle:
            return "중"
        case .low:
            return "하"
        }
    }
    
    var listTitle: String {
        switch self {
        case .high:
            return "!!!"
        case .middle:
            return "!!"
        case .low:
            return "!"
        }
    }
}
