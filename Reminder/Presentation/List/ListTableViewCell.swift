//
//  ListTableViewCell.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit

final class ListTableViewCell: BaseTableViewCell {
    
    private let accessoryButton = UIButton()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let dateLabel = UILabel()
    private let tagLabel = UILabel()
    
    private let accessoryLabelStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func configureHierarchy() {
        
        contentView.addSubview(accessoryButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(accessoryLabelStackView)
        accessoryLabelStackView.addArrangedSubview(dateLabel)
        accessoryLabelStackView.addArrangedSubview(tagLabel)
    }
    
    override func configureUI() {
        
        titleLabel.text = "mock"
        titleLabel.fontType(what: .listTitle)
        
        subtitleLabel.text = "mock"
        subtitleLabel.fontType(what: .listSubTitle)
        
        tagLabel.text = "#mock"
        tagLabel.fontType(what: .listTag)
        
        dateLabel.text = "2024.07.21"
        dateLabel.fontType(what: .listDateLabel)
        
        accessoryButton.setImage(UIImage(systemName: "circle"),
                                 for: .normal)
        accessoryButton.tintColor = .baseFont
        
        accessoryLabelStackView.axis = .horizontal
        accessoryLabelStackView.spacing = 4
    }
    
    override func configureLayout() {
        
        accessoryButton.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).offset(8)
            make.size.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(8)
            make.leading.equalTo(accessoryButton.snp.trailing).offset(16)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(accessoryButton.snp.height)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.directionalHorizontalEdges.equalTo(titleLabel.snp.directionalHorizontalEdges)
        }
        
        accessoryLabelStackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(4)
            make.leading.equalTo(accessoryButton.snp.trailing).offset(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(8)
        }
    }
    
}

//MARK: -  Override 제외 Method
extension ListTableViewCell {
    
    func updateContent() {
        
    }
    
}
