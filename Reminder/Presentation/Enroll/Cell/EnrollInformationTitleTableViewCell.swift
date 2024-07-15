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
    private let contentLabel = UILabel()
    private var cellType: EnrollSections?
    weak var viewModel: EnrollViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentLabel.text = .none
        expandSwitch.isOn = false
    }
    
    override func configureHierarchy() {
        
        contentView.addSubview(iconAndTitleView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(expandSwitch)
    }
    
    override func configureUI() {
        super.configureUI()
     
        contentLabel.textAlignment = .right
    }
    
    override func configureLayout() {
        
        iconAndTitleView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).inset(8)
            make.verticalEdges.equalTo(contentView.snp.verticalEdges).inset(8)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconAndTitleView.snp.trailing)
            make.centerY.equalTo(iconAndTitleView.snp.centerY)
        }
        
        expandSwitch.snp.makeConstraints { make in
            make.leading.equalTo(contentLabel.snp.trailing).offset(16)
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
        case .pin:
            viewModel?.applyInput(.pinToggle)
        default:
            return
        }
        
    }
    
    func updateContent(type: EnrollSections, isExpand: Bool) {
        
        cellType = type
        iconAndTitleView.updateContent(type: type)
        expandSwitch.isOn = isExpand
        
        switch type {
        
        case .deadLine:
            if let deadLine = viewModel?.deadLine {
                contentLabel.fontType(what: .listDateLabel)
                contentLabel.text = DateManager.shared.formattedDate(date: deadLine)
            }
            
            if expandSwitch.isOn == false {
                contentLabel.text = ""
            }
        case .tag:
           return
        case .priority:
            contentLabel.fontType(what: .listSubTitle)
        default:
            break
        }
    }
}
