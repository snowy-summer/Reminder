//
//  HomeCollectionViewSection.swift
//  Reminder
//
//  Created by 최승범 on 7/10/24.
//

import Foundation

enum HomeCollectionViewSection: Int, CaseIterable {
    case defaultList
    case customList
    
    var sectionTitle: String {
        switch self {
            
        case .customList:
            return "나의 목록"
        default:
            return ""
        }
    }
}
