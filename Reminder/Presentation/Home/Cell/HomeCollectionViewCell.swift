//
//  HomeCollectionViewCell.swift
//  Reminder
//
//  Created by 최승범 on 7/3/24.
//

import UIKit
import SnapKit

final class HomeCollectionViewCell: BaseCollectionViewCell {
    
    private let iconImage = UIImageView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configureHierarchy() {
        
        contentView.addSubview(iconImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
    }
    
    override func configureUI() {
        
        contentView.backgroundColor = #colorLiteral(red: 0.1098036841, green: 0.1098041013, blue: 0.1183908954, alpha: 1)
        contentView.layer.cornerRadius = 12
        contentView.layer.cornerCurve = .continuous
        
        titleLabel.fontType(what: .listSubTitle)
        countLabel.fontType(what: .todoCountLabel)
        countLabel.textAlignment = .right
    }
    
    override func configureLayout() {
        
        iconImage.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(8)
            make.height.width.equalTo(contentView.snp.height).multipliedBy(0.4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom).offset(8)
            make.leading.equalTo(iconImage).inset(4)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(8)
            make.trailing.equalTo(contentView.snp.trailing).inset(16)
        }
    }
    
    func updateContent(type: HomeCollectionViewCellType) {
        
        
        var config = UIImage.SymbolConfiguration(paletteColors: [ .white, type.iconTintColor])
        config = config.applying(UIImage.SymbolConfiguration(weight: .bold))
        
        let image = UIImage(systemName: type.iconName,
                            withConfiguration: config)
        iconImage.image = image
        
        titleLabel.text = type.title
        countLabel.text = String(type.dataCount)
        
    }
}
