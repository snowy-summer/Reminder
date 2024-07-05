//
//  HomeCollectionViewCellType.swift
//  Reminder
//
//  Created by 최승범 on 7/3/24.
//

import UIKit
import RealmSwift

enum HomeCollectionViewCellType:Int, CaseIterable {
    case today
    case will
    case all
    case pin
    case done
    
    var title: String {
        switch self {
        case .today:
            return "오늘"
        case .will:
            return "예정"
        case .all:
            return "전체"
        case .pin:
            return "깃발 표시"
        case .done:
            return "완료"
        }
    }
    
    var iconName: String {
        switch self {
        case .today:
            return "calendar.circle.fill"
        case .will:
            return "calendar.circle.fill"
        case .all:
            return "tray.circle.fill"
        case .pin:
            return "flag.circle.fill"
        case .done:
            return "checkmark.circle.fill"
        }
    }
    
    var iconTintColor: UIColor {
        switch self {
        case .today:
            return .tintColor
        case .will:
            return #colorLiteral(red: 0.9982114434, green: 0.3084382713, blue: 0.2676828206, alpha: 1)
        case .all:
            return #colorLiteral(red: 0.3873056769, green: 0.3873063028, blue: 0.4006001353, alpha: 1)
        case .pin:
            return #colorLiteral(red: 1, green: 0.6641262174, blue: 0.07634276897, alpha: 1)
        case .done:
            return #colorLiteral(red: 0.4365830421, green: 0.4938989282, blue: 0.5340322852, alpha: 1)
        }
    }
    
    var data: Results<Todo> {
        let results = DataBaseManager.shared.read(Todo.self)
        
        switch self {
        case .today:
           
            return results.where {
                $0.deadLine == Date()
            }
        case .will:
            
            let futureResults = results.where {
                $0.deadLine != nil && $0.deadLine > Date.now
            }
            
            return futureResults
            
        case .all:
            return results
            
        case .pin:
            return results.where {
                $0.isPined == true
            }
            
        case .done:
            return results.where {
                $0.isDone == true
            }
        }
    }
    
    var dataCount: Int {
        let results = DataBaseManager.shared.read(Todo.self)
        
        switch self {
        case .today:
            
            return results.where {
                $0.deadLine == Date()
            }.count
            
        case .will:
            
            let futureResults = results.where {
                $0.deadLine != nil && $0.deadLine > Date()
            }

            return futureResults.count
            
        case .all:
            return results.count
            
        case .pin:
            
            return results.where {
                $0.isPined == true
            }.count
            
        case .done:
            
            return results.where {
                $0.isDone == true
            }.count
        }
    }
    
}
