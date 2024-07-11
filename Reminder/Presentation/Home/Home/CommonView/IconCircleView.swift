//
//  IconCircleView.swift
//  Reminder
//
//  Created by 최승범 on 7/11/24.
//

import UIKit
import SnapKit

final class IconCircleView: UIView {
    
    private let iconImageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureUI()
        configureLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.width / 2
    }
    
    func updateContent(iconName: String,
                       color: UIColor) {
        
        backgroundColor = color
        iconImageView.image = UIImage(systemName: iconName)
    }
    
}

// MARK: - Configuration
extension IconCircleView {
    
    private func configureHierarchy() {
        
        addSubview(iconImageView)
    }
    
    private func configureUI() {

        iconImageView.tintColor = .baseFont
    }
    
    private func configureLayout() {
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.size.equalTo(self.snp.size).multipliedBy(0.5)
        }
    }
}
