//
//  HomeHeaderView.swift
//  Reminder
//
//  Created by 최승범 on 7/3/24.
//

import UIKit
import SnapKit

final class HomeHeaderView: UICollectionReusableView {
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTitle() {
        
        addSubview(titleLabel)
        
        titleLabel.text = "전체"
        titleLabel.fontType(what: .listHeaderTitle)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).inset(8)
            make.verticalEdges.equalTo(self)
        }
    }
    
    func updateContent(title: String) {
        
        titleLabel.text = title
    }
}
