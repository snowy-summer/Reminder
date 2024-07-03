//
//  DesignOfToolBarButton.swift
//  Reminder
//
//  Created by 최승범 on 7/3/24.
//

import Foundation

enum ToolBarButtonType {
    case addTodo
    case addList
    
    var title: String {
        switch self {
        case .addTodo:
            return "새로운 할 일 "
        case .addList:
            return "목록 추가"
        }
    }
    
    var imageName: String {
        switch self {
        case .addTodo:
            return "plus.circle.fill"
        case .addList:
            return ""
        }
    }
}
