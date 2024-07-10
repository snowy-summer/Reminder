//
//  AddFolderViewController.swift
//  Reminder
//
//  Created by 최승범 on 7/8/24.
//

import UIKit
import SnapKit

final class AddFolderViewController: BaseViewController {
    
    private let nameTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureNavigationBar() {
        
        let saveItem = UIBarButtonItem(title: "저장",
                                       style: .plain,
                                       target: self,
                                       action: #selector(saveFolder))
                                       
        
        navigationItem.rightBarButtonItem = saveItem
        
        let popItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(dismissVC))
        
        navigationItem.leftBarButtonItem = popItem
    }
    
    override func configureHierarchy() {
        view.addSubview(nameTextField)
    }
    
    override func configureUI() {
        super.configureUI()
        
        nameTextField.backgroundColor = .cell
        nameTextField.placeholder = "폴더 이름을 입력하세요"
    }
    
    override func configureLayout() {
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
}

//MARK: - Method
extension AddFolderViewController {
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc private func saveFolder() {
        
        if let text = nameTextField.text,
           !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            let folder = CustomTodoFolder(name: text)
            
//            DataBaseManager.shared.add(folder)
        }
        
        dismiss(animated: true)
        
    }
}
