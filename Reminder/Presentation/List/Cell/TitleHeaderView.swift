//
//  ListTableHeaderView.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit
import SnapKit

final class TitleHeaderView: UIView {
    
    private let titleLabel = UILabel()
    
    init(type: HomeCollectionViewCellType) {
        super.init(frame: .zero)
        configureTitle()
        titleLabel.text = type.title
        titleLabel.textColor = type.iconTintColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTitle() {
        
        addSubview(titleLabel)
        
        titleLabel.fontType(what: .listHeaderTitle)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self)
            make.verticalEdges.equalTo(self)
        }
    }
    
    func updateContent(title: String) {
        
        titleLabel.text = title
    }
}
