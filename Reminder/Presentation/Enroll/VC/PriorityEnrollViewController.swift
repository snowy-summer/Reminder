//
//  PriorityEnrollViewController.swift
//  Reminder
//
//  Created by 최승범 on 7/3/24.
//

import UIKit
import SnapKit

final class PriorityEnrollViewController: BaseViewController {
    
    private let priorityControl = UISegmentedControl(items: ["상", "중", "하"])
    var changeValue: ((Int) -> Void)?
    
    init(value: Int?) {
        super.init(nibName: nil, bundle: nil)
        
        if let priority = value {
            priorityControl.selectedSegmentIndex = priority
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
        changeValue?(priorityControl.selectedSegmentIndex)
    }

    override func configureHierarchy() {
        
        view.addSubview(priorityControl)
    }
    
    override func configureUI() {
        
        
       priorityControl.addTarget(self,
                                   action: #selector(selectPriority),
                                   for: .valueChanged)
    }
    
    override func configureLayout() {
        
        priorityControl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc private func selectPriority() {
        
    }
}

