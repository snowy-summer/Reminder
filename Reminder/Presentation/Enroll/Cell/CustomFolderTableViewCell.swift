//
//  CustomFolderTableViewCell.swift
//  Reminder
//
//  Created by 최승범 on 7/13/24.
//

import UIKit
import SnapKit

final class CustomFolderTableViewCell: BaseTableViewCell {
    
    private let iconCircleView = IconView()
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconCircleView.layoutIfNeeded()
        iconCircleView.layer.cornerRadius = iconCircleView.frame.width / 2
    }
    
    override func configureHierarchy() {
        
        contentView.addSubview(iconCircleView)
        contentView.addSubview(titleLabel)
    }
    
    override func configureUI() {
        
        contentView.backgroundColor = .cell
        
        titleLabel.fontType(what: .listTitle)
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
    }
   
    func updateContent(data: CustomTodoFolder?) {
        
        if let data = data {
            titleLabel.text = data.name
            let color = UIColor(red: data.redColor,
                                green: data.greenColor,
                                blue: data.blueColor,
                                alpha: 1.0)
            iconCircleView.updateContent(iconName: data.iconName, color: color)
        } else {
            titleLabel.text = "없음"
        }

    }
}
