//
//  HomeCustomListTypeCell.swift
//  Reminder
//
//  Created by 최승범 on 7/10/24.
//

import UIKit
import SnapKit

final class HomeCustomListTypeCell: BaseCollectionViewCell {
    
    private let iconImage = UIImageView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    private let nextButtonImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func prepareForReuse() {
        iconImage.image = UIImage(named: "list.bullet")
        titleLabel.text = ""
        countLabel.text = "0"
    }
    
    override func configureHierarchy() {
        
        contentView.addSubview(iconImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(nextButtonImageView)
    }
    
    override func configureUI() {
        
        contentView.backgroundColor = .cell
        
        titleLabel.fontType(what: .listTitle)
        countLabel.fontType(what: .listSubTitle)
        countLabel.textAlignment = .right
        
        nextButtonImageView.image = UIImage(named: "chevron.forward")
        nextButtonImageView.tintColor = .gray
    }
    
    override func configureLayout() {
        
        iconImage.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(contentView).inset(8)
            make.width.height.equalTo(contentView.snp.width).multipliedBy(0.1)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.leading.equalTo(iconImage.snp.trailing).offset(8)
        }
    
        nextButtonImageView.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).inset(16)
            make.verticalEdges.equalTo(contentView).inset(8)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(8)
            make.trailing.equalTo(nextButtonImageView.snp.leading).inset(16)
        }
    }
   
    
    func updateContent(data: CustomTodoFolder) {
        
        titleLabel.text = data.name
        iconImage.image = UIImage(named: data.iconName)
        countLabel.text = String(data.todoList.count)
    }
}
