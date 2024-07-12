//
//  TitleSectionCell.swift
//  Reminder
//
//  Created by 최승범 on 7/10/24.
//

import UIKit
import SnapKit

final class TitleSectionCell: BaseTableViewCell {
    
    private let iconCircleView = IconView()
    private let titleTextField = UITextField()
    var texFieldChanged: ((String?) -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconCircleView.layer.cornerRadius = iconCircleView.frame.width / 2
    }
    
    override func configureHierarchy() {
        
        contentView.addSubview(iconCircleView)
        contentView.addSubview(titleTextField)
    }
    
    override func configureUI() {
        
        contentView.backgroundColor = .cell
        
        iconCircleView.backgroundColor = DesignOfFolderColor.blue.colorValue
        iconCircleView.layer.shadowRadius = 16
        iconCircleView.layer.shadowOpacity = 0.2
        iconCircleView.updateContent(iconName: DesignOfFolderIcon.list.iconName,
                                     color: .baseFont)
        
        titleTextField.placeholder = "목록 이름"
        titleTextField.font = DesignOfFont.todoCountLabel.font
        titleTextField.backgroundColor = .iconBaseBackgroud
        titleTextField.layer.cornerRadius = 8
        titleTextField.textAlignment = .center
    }
    
    override func configureLayout() {
        
        iconCircleView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(20)
            make.width.height.equalTo(contentView.snp.width).multipliedBy(0.24)
            make.centerX.equalTo(contentView.snp.centerX)
        }
    
        titleTextField.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalTo(contentView).inset(20)
            make.top.equalTo(iconCircleView.snp.bottom).offset(20)
            make.bottom.equalTo(contentView.snp.bottom).inset(20)
        }
    }
    
    override func configureGestureAndButtonAction() {
        titleTextField.addTarget(self,
                                 action: #selector(textFieldDidChange),
                                 for: .allEditingEvents)
    }
    
    func updateContent(folderName: String?,
                       iconName: String,
                       color: UIColor) {
        
        titleTextField.text = folderName
        iconCircleView.updateContent(iconName: iconName,
                                     color: color)
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        texFieldChanged?(sender.text)
    }
    
}
