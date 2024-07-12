//
//  AddFolderSection.swift
//  Reminder
//
//  Created by 최승범 on 7/10/24.
//

import UIKit

enum AddFolderSection: Int, CaseIterable {
    case title
    case selectColor
    case selectIcon
    
    var cellCount: Int {
        switch self {
        case .title:
            return 1
        case .selectColor:
            return DesignOfFolderColor.allCases.count
        case .selectIcon:
            return DesignOfFolderIcon.allCases.count
        }
    }
    
    var layoutSection: NSCollectionLayoutSection {
        
        switch self {
        case .title:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.28))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
        
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 16,
                                                            leading: 16,
                                                            bottom: 16,
                                                            trailing: 16)
            
            return section
            
        case .selectColor:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.16),
                                                  heightDimension: .fractionalWidth(0.16))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(0.16))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
        
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 8,
                                                            leading: 16,
                                                            bottom: 0,
                                                            trailing: 0)
            
            return section
            
        case .selectIcon:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.16),
                                                  heightDimension: .fractionalWidth(0.16))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(0.16))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
        
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 8,
                                                            leading: 8,
                                                            bottom: 0,
                                                            trailing: 0)
            
            return section
            
        }
    }
}
