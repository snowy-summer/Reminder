//
//  HomeCustomFolderTypeCell.swift
//  Reminder
//
//  Created by 최승범 on 7/10/24.
//

import UIKit
import SnapKit

final class HomeCustomFolderTypeCell: BaseCollectionViewCell {
    
    private let iconCircleView = IconView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    private let nextButtonImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconCircleView.layoutIfNeeded()
        iconCircleView.layer.cornerRadius = iconCircleView.frame.width / 2
    }
    
    override func configureHierarchy() {
        
        contentView.addSubview(iconCircleView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(nextButtonImageView)
    }
    
    override func configureUI() {
        
        contentView.backgroundColor = .cell
        
        titleLabel.fontType(what: .listTitle)
        countLabel.fontType(what: .listSubTitle)
        countLabel.textAlignment = .right
        
        nextButtonImageView.image = UIImage(systemName: "chevron.forward")
        nextButtonImageView.tintColor = .gray
    }
    
    override func configureLayout() {
        
        iconCircleView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(8)
            make.size.equalTo(32)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconCircleView.snp.trailing).offset(8)
            make.centerY.equalTo(contentView.snp.centerY)
            make.height.equalTo(44)
        }
    
        nextButtonImageView.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).inset(16)
            make.centerY.equalTo(contentView.snp.centerY)
            make.height.equalTo(20)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.height.equalTo(20)
            make.trailing.equalTo(nextButtonImageView.snp.leading).inset(-20)
        }
    }
   
    func updateContent(data: CustomTodoFolder) {
        
        titleLabel.text = data.name
        let color = UIColor(red: data.redColor,
                            green: data.greenColor,
                            blue: data.blueColor,
                            alpha: 1.0)
        iconCircleView.updateContent(iconName: data.iconName, color: color)
        countLabel.text = String(data.todoList.count)
    }
}
