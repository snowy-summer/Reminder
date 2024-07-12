//
//  IconAndTitleView.swift
//  Reminder
//
//  Created by 최승범 on 7/12/24.
//

import UIKit
import SnapKit

final class IconAndTitleView: UIView {
    
    private let titleLabel = UILabel()
    private let iconView = UIView()
    private let iconImageView = UIImageView()
    private let contentLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(iconView)
        iconView.addSubview(iconImageView)
    }
    
    private func configureUI() {
        
        titleLabel.fontType(what: .enrollCellTitle)
        
        iconView.layer.cornerRadius = 8
        iconView.backgroundColor = .orange
    }
    
    private func configureLayout() {
        
        iconView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(8)
            make.verticalEdges.equalTo(self.snp.verticalEdges).inset(8)
            make.width.equalTo(iconView.snp.height)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview().inset(4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(8)
            make.verticalEdges.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).inset(20)
            make.verticalEdges.equalToSuperview()
        }
    }
    
    func updateContent(type: EnrollSections) {
        
        titleLabel.text = type.text
        iconImageView.image = UIImage(systemName: type.iconName)
        iconImageView.tintColor = .baseFont
        iconView.backgroundColor = type.backgroundColor
        
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
