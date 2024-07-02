//
//  DesignOfFont.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit

enum DesignOfFont {
    case enrollPlaceHolder
    case enrollCellTitle
    case listHeaderTitle
    case listTitle
    case listSubTitle
    case listDateLabel
    case listTag
    
    var font: UIFont {
        switch self {
        case.enrollPlaceHolder:
            return .systemFont(ofSize: 17, weight: .semibold)
        case.enrollCellTitle:
            return .systemFont(ofSize: 17, weight: .semibold)
        case .listHeaderTitle:
            return .systemFont(ofSize: 32, weight: .semibold)
        case .listTitle:
            return .systemFont(ofSize: 17, weight: .semibold)
        case .listSubTitle:
            return .systemFont(ofSize: 14, weight: .semibold)
        case .listDateLabel:
            return .systemFont(ofSize: 12, weight: .semibold)
        case .listTag:
            return .systemFont(ofSize: 12, weight: .semibold)
        }
    }
    
    var color: UIColor {
        switch self {
        case .enrollPlaceHolder:
            return .lightGray
        case .enrollCellTitle:
            return .baseFont
        case .listHeaderTitle:
            return .tintColor
        case .listTitle:
            return .baseFont
        case .listSubTitle:
            return .lightGray
        case .listDateLabel:
            return .lightGray
        case .listTag:
            return .tag
        }
    }
}
