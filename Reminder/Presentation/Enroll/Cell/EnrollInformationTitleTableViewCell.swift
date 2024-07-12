//
//  EnrollDateTableViewCell.swift
//  Reminder
//
//  Created by 최승범 on 7/12/24.
//

import UIKit
import SnapKit

final class EnrollInformationTitleTableViewCell: BaseTableViewCell {
    
    private let iconAndTitleView = IconAndTitleView()
    private let expandSwitch = UISwitch()
    private var cellType: EnrollSections?
    weak var viewModel: EnrollViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func configureHierarchy() {
        
        contentView.addSubview(iconAndTitleView)
        contentView.addSubview(expandSwitch)
    }
    
    override func configureUI() {
        super.configureUI()
        
    }
    
    override func configureLayout() {
        
        iconAndTitleView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).inset(8)
            make.verticalEdges.equalTo(contentView.snp.verticalEdges).inset(8)
        }
        
        expandSwitch.snp.makeConstraints { make in
            make.leading.equalTo(iconAndTitleView.snp.trailing)
            make.trailing.equalTo(contentView.snp.trailing).inset(16)
            make.centerY.equalTo(iconAndTitleView.snp.centerY)
        }
    }
    
    override func configureGestureAndButtonAction() {
        expandSwitch.addTarget(self,
                               action: #selector(turnValueSwitch),
                               for: .valueChanged)
    }
    
    @objc private func turnValueSwitch() {
        
        switch cellType {

        case .deadLine:
            viewModel?.applyInput(.expandDateCell)
        case .tag:
            viewModel?.applyInput(.expandTagCell)
        default:
            return
        }
        
    }
    
    func updateContent(type: EnrollSections, isExpand: Bool) {
        
        cellType = type
        iconAndTitleView.updateContent(type: type)
        expandSwitch.isOn = isExpand
//
//        titleLabel.text = type.text
//        iconImageView.image = UIImage(systemName: type.iconName)
//        iconImageView.tintColor = .baseFont
//        iconView.backgroundColor = type.backgroundColor
//        contentLabel.text = content
//        thumbnailImageView.isHidden = true
//        contentLabel.isHidden = false
//        
//        switch type {
//        
//        case .deadLine:
//            contentLabel.fontType(what: .listDateLabel)
//        case .tag:
//            contentLabel.fontType(what: .listTag)
//        case .priority:
//            contentLabel.fontType(what: .listSubTitle)
//        default:
//            break
//        }
    }
}
