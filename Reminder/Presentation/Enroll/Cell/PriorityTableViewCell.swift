//
//  PriorityTableViewCell.swift
//  Reminder
//
//  Created by 최승범 on 7/14/24.
//

import UIKit
import SnapKit

final class PriorityTableViewCell: BaseTableViewCell {
    
    private let iconAndTitleView = IconAndTitleView()
    private let contentLabel = UILabel()
    private let menuButton = UIButton()
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
        contentView.addSubview(menuButton)
    }
    
    override func configureUI() {
        super.configureUI()
     
        menuButton.setImage( UIImage(systemName: "chevron.up.chevron.down"),
                             for: .normal)
        menuButton.tintColor = .lightGray
        menuButton.menu = UIMenu(children: configureMenu())
        menuButton.showsMenuAsPrimaryAction = true
        
        contentLabel.textAlignment = .right
        contentLabel.fontType(what: .listSubTitle)
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
        
        menuButton.snp.makeConstraints { make in
            make.leading.equalTo(contentLabel.snp.trailing)
            make.trailing.equalTo(contentView.snp.trailing).inset(16)
            make.verticalEdges.equalTo(contentView.snp.verticalEdges).inset(8)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.1)
        }
    }
    
    override func configureGestureAndButtonAction() {
        
        
    }
    
    private func configureMenu() -> [UIAction] {
        
        let no = UIAction(title: "없음") { [weak self] _ in
            guard let self = self else { return }
            viewModel?.applyInput(.selectPriority(0))
        }
        
        let low = UIAction(title: "낮음") { [weak self] _ in
            guard let self = self else { return }
            viewModel?.applyInput(.selectPriority(1))
        }
        
        let middle = UIAction(title: "중간") { [weak self] _ in
            guard let self = self else { return }
            viewModel?.applyInput(.selectPriority(2))
        }
        
        let high = UIAction(title: "높음") { [weak self] _ in
            guard let self = self else { return }
            viewModel?.applyInput(.selectPriority(3))
        }
        
        let items = [
           no,
           low,
           middle,
           high
        ]
    
        return items
    }
    
    func updateContent() {
        
        iconAndTitleView.updateContent(type: EnrollSections.priority)
        
        guard let viewModel = viewModel else { return }
        contentLabel.text = PriorityType(rawValue: viewModel.priority)?.title
        
    }
}
