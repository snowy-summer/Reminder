//
//  ListTableViewCell.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit

final class ListTableViewCell: BaseTableViewCell {
    
    private let accesaryButton = UIButton()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let dateLabel = UILabel()
    private let tagLabel = UILabel()
    
    private let accesaryLabelStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func configureHierarchy() {
        
    }
    
    override func configureUI() {
        
    }
    
    override func configureLayout() {
        
    }
}
