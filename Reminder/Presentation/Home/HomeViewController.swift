//
//  HomeViewController.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit
import SnapKit

final class HomeViewController: BaseViewController {
    
    private let button = UIButton()
    private let button2 = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pushVC),
                                               name: .pushNotification,
                                               object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .pushNotification,
                                                  object: nil)
    }
    
    override func configureHierarchy() {
        
        view.addSubview(button)
        view.addSubview(button2)
    }
    
    override func configureUI() {
        
        button.backgroundColor = .red
        button2.backgroundColor = .blue
        button.addTarget(self,
                         action: #selector(modalVC),
                         for: .touchUpInside)
        button2.addTarget(self,
                         action: #selector(pushVC),
                         for: .touchUpInside)
    }
    
    override func configureLayout() {
        
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(50)
        }
        
        button2.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(50)
        }
    }
    
    @objc private func modalVC() {
        
        let nv = UINavigationController(rootViewController: EnrollViewController())
        nv.modalPresentationStyle = .fullScreen
        
        present(nv,
                animated: true)
    }
    
    @objc private func pushVC() {
       
        navigationController?.pushViewController(ListViewController(), animated: true)
    }
}
