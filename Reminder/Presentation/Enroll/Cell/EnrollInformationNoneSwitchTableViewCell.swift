//
//  EnrollInformationNoneSwitchCell.swift
//  Reminder
//
//  Created by 최승범 on 7/13/24.
//

import UIKit
import SnapKit

final class EnrollInformationNoneSwitchCell: BaseTableViewCell {
    
    private let iconAndTitleView = IconAndTitleView()
    private let contentLabel = UILabel()
    private let accessoryImageView = UIImageView()
    private var cellType: EnrollSections?
    weak var viewModel: EnrollViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentLabel.text = .none
    }
    
    override func configureHierarchy() {
        
        contentView.addSubview(iconAndTitleView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(accessoryImageView)
    }
    
    override func configureUI() {
        super.configureUI()
     
        accessoryImageView.image = UIImage(systemName: "chevron.forward")
        accessoryImageView.tintColor = .lightGray
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
        
        accessoryImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentLabel.snp.trailing).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).inset(16)
            make.centerY.equalTo(iconAndTitleView.snp.centerY)
        }
    }
    
    func updateContent(type: EnrollSections, content: String?) {
        
        cellType = type
        iconAndTitleView.updateContent(type: type)
        contentLabel.text = content
        
    }
}
