//
//  DesignOfFolderColor.swift
//  Reminder
//
//  Created by 최승범 on 7/10/24.
//

import UIKit

enum DesignOfFolderColor: Int, CaseIterable {
    
    case red
    case orange
    case yellow
    case green
    case skyBlue
    case blue
    case purple
    case hotPink
    case pink
    case brown
    case gray
    case peach
    
    var colorValue: UIColor {
        switch self {
        case .red:
            return #colorLiteral(red: 1, green: 0.1513742208, blue: 0.1543981433, alpha: 1)
        case .orange:
            return #colorLiteral(red: 1, green: 0.6005576253, blue: 0, alpha: 1)
        case .yellow:
            return #colorLiteral(red: 1, green: 0.8232461214, blue: 0, alpha: 1)
        case .green:
            return #colorLiteral(red: 0, green: 0.8340885043, blue: 0.2753156126, alpha: 1)
        case .skyBlue:
            return #colorLiteral(red: 0.3611992002, green: 0.7740653157, blue: 1, alpha: 1)
        case .blue:
            return #colorLiteral(red: 0, green: 0.5234797597, blue: 1, alpha: 1)
        case .purple:
            return #colorLiteral(red: 0.3711829782, green: 0.3563814461, blue: 0.9350737333, alpha: 1)
        case .hotPink:
            return #colorLiteral(red: 1, green: 0.2202344835, blue: 0.4621617794, alpha: 1)
        case .pink:
            return #colorLiteral(red: 0.8853535056, green: 0.477114141, blue: 0.983972609, alpha: 1)
        case .brown:
            return #colorLiteral(red: 0.810480237, green: 0.6445638537, blue: 0.4336052537, alpha: 1)
        case .gray:
            return #colorLiteral(red: 0.4306129217, green: 0.4961214662, blue: 0.5335709453, alpha: 1)
        case .peach:
            return #colorLiteral(red: 0.961666286, green: 0.6948239207, blue: 0.6702269316, alpha: 1)
        }
    }
}
