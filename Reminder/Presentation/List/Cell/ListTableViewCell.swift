//
//  ListTableViewCell.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit

final class ListTableViewCell: BaseTableViewCell {
    
    private let accessoryButton = UIButton()
    private let priorityLabel = UILabel()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let dateLabel = UILabel()
    private let tagLabel = UILabel()
    private let accessoryLabelStackView = UIStackView()
    private let titleLabelStackView = UIStackView()
    
    var changeState: (() -> Bool)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        subTitleLabel.text = .none
        dateLabel.text = .none
        tagLabel.text = .none
    }
    
    override func configureHierarchy() {
        
        contentView.addSubview(accessoryButton)
        contentView.addSubview(titleLabelStackView)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(accessoryLabelStackView)
        titleLabelStackView.addArrangedSubview(priorityLabel)
        titleLabelStackView.addArrangedSubview(titleLabel)
        accessoryLabelStackView.addArrangedSubview(dateLabel)
        accessoryLabelStackView.addArrangedSubview(tagLabel)
        
    }
    
    override func configureUI() {
        super.configureUI()
        
        priorityLabel.fontType(what: .listPriority)
        
        titleLabel.fontType(what: .listTitle)
        
        subTitleLabel.fontType(what: .listSubTitle)
        
        tagLabel.fontType(what: .listTag)
        
        dateLabel.fontType(what: .listDateLabel)
        
        accessoryButton.setImage(UIImage(systemName: "circle"),
                                 for: .normal)
        accessoryButton.tintColor = .baseFont
        
        titleLabelStackView.axis = .horizontal
        titleLabelStackView.spacing = 4
        accessoryLabelStackView.axis = .horizontal
        accessoryLabelStackView.spacing = 4
    }
    
    override func configureLayout() {
        
        accessoryButton.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).offset(8)
            make.size.equalTo(20)
        }
        
        titleLabelStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(8)
            make.leading.equalTo(accessoryButton.snp.trailing).offset(16)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(accessoryButton.snp.height)
        }
        
        priorityLabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(12)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabelStackView.snp.bottom).offset(4)
            make.leading.equalTo(accessoryButton.snp.trailing).offset(16)
            make.trailing.equalTo(titleLabel.snp.trailing)
        }
        
        accessoryLabelStackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(4)
            make.leading.equalTo(accessoryButton.snp.trailing).offset(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(8)
            make.width.lessThanOrEqualTo(contentView.snp.width).multipliedBy(0.8)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(contentView.snp.width).multipliedBy(0.6)
        }
    }
    
    override func configureGestureAndButtonAction() {
        accessoryButton.addTarget(self,
                                  action: #selector(changeTodoState),
                                  for: .touchUpInside)
    }
}

//MARK: -  Override 제외 Method
extension ListTableViewCell {
    
    func updateContent(data: Todo) {
        
        if let priority = data.priority,
           let type = PriorityType(rawValue: priority) {
            priorityLabel.isHidden = false
            priorityLabel.text = type.listTitle
        } else {
            priorityLabel.isHidden = true
        }
        
        titleLabel.text = data.title
        subTitleLabel.text = data.subTitle
        
        if let deadLine = data.deadLine {
            dateLabel.text = DateManager.shared.formattedDate(date: deadLine)
        }
    
        var text = ""
        for tag in data.tag {
            text += "\(tag) "
        }
        
        tagLabel.text = text
        
        if data.isDone {
            accessoryButton.setImage(UIImage(systemName: "circle.inset.filled"),
                                     for: .normal)
        } else {
            accessoryButton.setImage(UIImage(systemName: "circle"),
                                     for: .normal)
        }
    }
    
    @objc private func changeTodoState() {
        guard let changeState = changeState else { return }
        if changeState() {
            accessoryButton.setImage(UIImage(systemName: "circle.inset.filled"),
                                     for: .normal)
        } else {
            accessoryButton.setImage(UIImage(systemName: "circle"),
                                     for: .normal)
        }
    
    }
    
}
