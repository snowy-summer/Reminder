//
//  IconSectionCell.swift
//  Reminder
//
//  Created by 최승범 on 7/10/24.
//

import UIKit
import SnapKit

final class IconSectionCell: BaseTableViewCell {
    
    private lazy var collecitionView = UICollectionView(frame: .zero,
                                                        collectionViewLayout: createCollectionViewLayout())
    
    override func configureHierarchy() {
        
        contentView.addSubview(collecitionView)
    }
    
    override func configureUI() {
        
        collecitionView.backgroundColor = .cell
        collecitionView.isScrollEnabled = false
        
        collecitionView.delegate = self
        collecitionView.dataSource = self
        
        collecitionView.register(SelectIconCollectionViewCell.self,
                                 forCellWithReuseIdentifier: SelectIconCollectionViewCell.identifier)
    }
    
    override func configureLayout() {
        
        collecitionView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(contentView)
        }
    }
    
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let collectioViewCompositonalLayout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            
            return AddFolderSection.selectIcon.layoutSection
        }
        
        return collectioViewCompositonalLayout
    }
}

//MARK: - CollectionView Delegate, DataSource
extension IconSectionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return DesignOfFolderIcon.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectIconCollectionViewCell.identifier,
                                                            for: indexPath) as? SelectIconCollectionViewCell
        else {
            
            return SelectIconCollectionViewCell()
        }
        
        cell.updateIcon(index: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
    }
}

