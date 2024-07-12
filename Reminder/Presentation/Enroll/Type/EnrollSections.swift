//
//  EnrollSections.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit

enum EnrollSections: Int, CaseIterable {
    case main
    case deadLine
    case tag
    case pin
    case priority
    case addImage
    
    var text: String {
        switch self {
        case .main:
            return "주요 내용"
        case .deadLine:
            return "날짜"
        case .tag:
            return "태그"
        case .pin:
            return "깃발"
        case .priority:
            return "우선 순위"
        case .addImage:
            return "이미지 추가"
        }
    }
    
    var iconName: String {
        switch self {
        case .deadLine:
            return "calendar"
        case .tag:
            return "tag.fill"
        case .pin:
            return "flag.fill"
        case .priority:
            return "star.fill"
        default:
            return ""
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
            
        case .deadLine:
            return #colorLiteral(red: 1, green: 0.1513743699, blue: 0.1607473493, alpha: 1)
        case .tag:
            return #colorLiteral(red: 0.4206221104, green: 0.4964048862, blue: 0.5379528403, alpha: 1)
        case .pin:
            return #colorLiteral(red: 1, green: 0.6005576253, blue: 0, alpha: 1)
        case .priority:
            return #colorLiteral(red: 1, green: 0.1513743699, blue: 0.1607473493, alpha: 1)
        default:
            return .tintColor
        }
    }
    
    enum Main: Int {
        case title
        case memo
        
        var text: String {
            switch self {
            case .title:
                return "제목"
            case .memo:
                return "메모"
            }
        }
        
    }
}
