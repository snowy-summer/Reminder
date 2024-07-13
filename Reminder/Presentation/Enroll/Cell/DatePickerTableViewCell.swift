//
//  DatePickerTableViewCell.swift
//  Reminder
//
//  Created by 최승범 on 7/12/24.
//

import UIKit
import SnapKit

final class DatePickerTableViewCell: BaseTableViewCell {
    
    private var datePicker = UIDatePicker()
    weak var viewModel: EnrollViewModel?
    
    override func configureHierarchy() {
        
        contentView.addSubview(datePicker)
    }
    
    override func configureUI() {
     
        datePicker.preferredDatePickerStyle = .inline
    }
    
    override func configureLayout() {
        
        datePicker.snp.makeConstraints { make in
            make.directionalEdges.equalTo(contentView.snp.directionalEdges).inset(8)
        }
        
    }
    
    override func configureGestureAndButtonAction() {
        
        datePicker.addTarget(self,
                             action: #selector(selectDate),
                             for: .valueChanged)
    }
    
    @objc private func selectDate() {
    
        viewModel?.applyInput(.selectDate(datePicker.date))
    }
}
