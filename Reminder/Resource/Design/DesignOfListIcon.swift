//
//  DesignOfListIcon.swift
//  Reminder
//
//  Created by 최승범 on 7/10/24.
//

import Foundation

enum DesignOfListIcon {
    case list
    
    var iconName: String {
        switch self {
        case .list:
            return "list.bullet"
        }
    }
}
