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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func configureHierarchy() {
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(pushButton)
    }
    
    override func configureUI() {
        
        titleLabel.fontType(what: .enrollCellTitle)
        
        pushButton.setImage(UIImage(systemName: "chevron.forward"),
                            for: .normal)
        pushButton.tintColor = .lightGray
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
    }
    
    func updateContent(type: EnrollSections) {
        
        titleLabel.text = type.text
    }
}
