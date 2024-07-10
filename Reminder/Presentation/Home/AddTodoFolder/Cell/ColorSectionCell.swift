//
//  ColorSectionCell.swift
//  Reminder
//
//  Created by 최승범 on 7/10/24.
//

import UIKit
import SnapKit

final class ColorSectionCell: BaseTableViewCell {
    
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
        
        collecitionView.register(SelectColorCollectionViewCell.self,
                                 forCellWithReuseIdentifier: SelectColorCollectionViewCell.identifier)
    }
    
    override func configureLayout() {
        
        collecitionView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(contentView)
        }
    }
    
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let collectioViewCompositonalLayout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            
            return AddFolderSection.selectColor.layoutSection
        }
        
        return collectioViewCompositonalLayout
    }
}

//MARK: - CollectionView Delegate, DataSource
extension ColorSectionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return DesignOfFolderColor.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectColorCollectionViewCell.identifier,
                                                            for: indexPath) as? SelectColorCollectionViewCell
        else {
            
            return SelectColorCollectionViewCell()
        }
        
        cell.updateColor(index: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
    }
}
