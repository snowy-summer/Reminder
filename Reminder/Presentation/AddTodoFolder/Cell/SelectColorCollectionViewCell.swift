//
//  SelectColorCollectionViewCell.swift
//  Reminder
//
//  Created by 최승범 on 7/10/24.
//

import UIKit
import SnapKit

final class SelectColorCollectionViewCell: BaseCollectionViewCell {
    
    private let colorView = UIView()
    private let selectView = UIView()

    override func configureHierarchy() {
        
        contentView.addSubview(selectView)
        contentView.addSubview(colorView)
    }
    
    override func configureUI() {
        
    
        selectView.layer.borderWidth = 3
        selectView.layer.borderColor = UIColor.gray.cgColor
        selectView.backgroundColor = .clear
        selectView.isHidden = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            selectView.layer.cornerRadius = selectView.frame.width / 2
            colorView.layer.cornerRadius = colorView.frame.width / 2
            
        }
    }
    
    override func configureLayout() {
        
        selectView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(contentView)
        }
        
        colorView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(selectView).inset(6)
        }
    
    }
    
    func updateColor(index: Int, selectedIndex: Int) {
        if index == selectedIndex {
            selectView.isHidden = false
        } else {
            selectView.isHidden = true
        }
        colorView.backgroundColor = DesignOfFolderColor(rawValue: index)?.colorValue
    }
}