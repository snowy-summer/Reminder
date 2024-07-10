//
//  HomeCollectionViewSection.swift
//  Reminder
//
//  Created by 최승범 on 7/10/24.
//

import UIKit

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
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        switch self {
        case .defaultList:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 8,
                                                         leading: 8,
                                                         bottom: 8,
                                                         trailing: 8)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.15))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
        
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 16,
                                                            leading: 16,
                                                            bottom: 16,
                                                            trailing: 16)
            
            return section
            
        case .customList:
            
            
            let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            
            
            return .list(using: configuration,
                         layoutEnvironment: environment)
        }
    }

}
