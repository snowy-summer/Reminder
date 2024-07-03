//
//  DeadLineViewController.swift
//  Reminder
//
//  Created by 최승범 on 7/3/24.
//

import UIKit
import SnapKit

final class DeadLineEnrollViewController: BaseViewController {
    
    private let datePicker = UIDatePicker()
    var changeValue: ((Date) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        changeValue?(datePicker.date)
    }
    
    override func configureHierarchy() {
        
        view.addSubview(datePicker)
    }
    
    override func configureUI() {
        
    }
    
    override func configureLayout() {
        
        datePicker.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
