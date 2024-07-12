//
//  TagCell.swift
//  Reminder
//
//  Created by 최승범 on 7/12/24.
//

import UIKit
import SnapKit

final class TagCell: BaseCollectionViewCell {
    
    private let tagTitle = UILabel()
    
    override func configureHierarchy() {
        
        contentView.addSubview(tagTitle)
    }
    
    override func configureUI() {
        
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = #colorLiteral(red: 0.2239803374, green: 0.511967957, blue: 1, alpha: 1)
    }
    
    override func configureLayout() {
        
        tagTitle.snp.makeConstraints { make in
            make.directionalEdges.equalTo(contentView.snp.directionalEdges).inset(4)
        }
    }
    
    func updateContent(title: String) {
        
        tagTitle.text = title
    }
}
