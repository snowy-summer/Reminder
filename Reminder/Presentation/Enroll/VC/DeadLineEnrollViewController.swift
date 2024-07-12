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
    
    init(value: Date?) {
        super.init(nibName: nil, bundle: nil)
        
        if let date = value {
            datePicker.date = date
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
