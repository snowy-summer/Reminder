//
//  EnrollSections.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import Foundation

enum EnrollSections: Int, CaseIterable {
    case main
    case deadLine
    case tag
    case priority
    case addImage
    
    var text: String {
        switch self {
        case .main:
            return "주요 내용"
        case .deadLine:
            return "마감일"
        case .tag:
            return "태그"
        case .priority:
            return "우선 순위"
        case .addImage:
            return "이미지 추가"
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
