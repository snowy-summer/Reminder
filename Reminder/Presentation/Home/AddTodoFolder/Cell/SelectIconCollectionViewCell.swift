//
//  SelectIconCollectionViewCell.swift
//  Reminder
//
//  Created by 최승범 on 7/10/24.
//

import UIKit
import SnapKit

final class SelectIconCollectionViewCell: BaseCollectionViewCell {
    
    private let iconCircleView = UIView()
    private let iconImageView = UIImageView()
    private let selectView = UIView()
    
    override func configureHierarchy() {
        
        contentView.addSubview(selectView)
        contentView.addSubview(iconCircleView)
        iconCircleView.addSubview(iconImageView)
    }
    
    override func configureUI() {
        
        selectView.layer.cornerRadius = selectView.frame.width / 2
        selectView.layer.borderWidth = 3
        selectView.layer.borderColor = UIColor.gray.cgColor
        selectView.backgroundColor = .clear
        selectView.isHidden = true
        
        iconCircleView.backgroundColor = .iconBaseBackgroud
        
        iconImageView.tintColor = .baseFont
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            selectView.layer.cornerRadius = selectView.frame.width / 2
            iconCircleView.layer.cornerRadius = iconCircleView.frame.width / 2
        }
    }
    
    override func configureLayout() {
        
        selectView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(contentView)
        }
        
        iconCircleView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(selectView).inset(6)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalTo(iconCircleView.snp.center)
            make.width.height.equalTo(iconCircleView.snp.width).multipliedBy(0.6)
        }
    }
    
    func updateIcon(index: Int) {
        guard let iconName = DesignOfFolderIcon(rawValue: index)?.iconName else { return }
        iconImageView.image = UIImage(systemName: iconName)
    }
}