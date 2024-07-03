//
//  EnrollExtraTableViewCell.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit
import SnapKit

final class EnrollExtraTableViewCell: BaseTableViewCell {
    
    private let titleLabel = UILabel()
    private let pushButton = UIButton()
    private let contentLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func configureHierarchy() {
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(pushButton)
        contentView.addSubview(contentLabel)
    }
    
    override func configureUI() {
        super.configureUI()
        
        titleLabel.fontType(what: .enrollCellTitle)
        
        pushButton.setImage(UIImage(systemName: "chevron.forward"),
                            for: .normal)
        pushButton.tintColor = .lightGray
        
        contentLabel.textAlignment = .right
    }
    
    override func configureLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(8)
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        pushButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).inset(8)
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.trailing.equalTo(pushButton.snp.leading).offset(-20)
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.4)
        }
    }
    
    func updateContent(type: EnrollSections, content: String?) {
        
        titleLabel.text = type.text
        contentLabel.text = content
        
        switch type {
        
        case .deadLine:
            contentLabel.fontType(what: .listDateLabel)
        case .tag:
            contentLabel.fontType(what: .listTag)
        case .priority:
            contentLabel.fontType(what: .listSubTitle)
        default:
            break
        }
    }
}
