//
//  TitleSectionCell.swift
//  Reminder
//
//  Created by 최승범 on 7/10/24.
//

import UIKit
import SnapKit

final class TitleSectionCell: BaseTableViewCell {
    
    private let iconCircleView = UIView()
    private let iconImageView = UIImageView()
    private let titleTextField = UITextField()
    var texFieldChanged: ((String?) -> Void)?
    
    override func configureHierarchy() {
        
        contentView.addSubview(iconCircleView)
        iconCircleView.addSubview(iconImageView)
        contentView.addSubview(titleTextField)
    }
    
    override func configureUI() {
        
        contentView.backgroundColor = .cell
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            iconCircleView.layer.cornerRadius = iconCircleView.frame.width / 2
        }
        
        iconCircleView.backgroundColor = DesignOfFolderColor.blue.colorValue
        iconCircleView.layer.shadowRadius = 16
        iconCircleView.layer.shadowOpacity = 0.2
        iconImageView.image = UIImage(systemName: DesignOfFolderIcon.list.iconName)
        iconImageView.tintColor = .baseFont
        
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
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalTo(iconCircleView.snp.center)
            make.width.height.equalTo(contentView.snp.width).multipliedBy(0.12)
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
        iconCircleView.backgroundColor = color
        iconImageView.image = UIImage(systemName: iconName)
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        texFieldChanged?(sender.text)
    }
    
}
