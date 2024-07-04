//
//  BaseViewController.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureHierarchy()
        configureUI()
        configureLayout()
        configureGestureAndButtonAction()
    }
     
    func configureNavigationBar() { }
    func configureHierarchy() { }
    func configureUI() {
        
        view.backgroundColor = .base
    }
    
    func configureLayout() { }
    func configureGestureAndButtonAction() { }
    
    func showAlert(title: String,
                   message: String,
                   confirmMessage: String,
                   completionHandler: @escaping (() -> Void)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: confirmMessage, style: .default) { _ in
            completionHandler()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
     
}
