//
//  TagViewController.swift
//  Reminder
//
//  Created by 최승범 on 7/3/24.
//

import UIKit
import SnapKit

final class TagEnrollViewController: BaseViewController {
    
    private let tagTextField = UITextField()
    private let addButton = UIButton()
    private let tagLabel = UILabel()
    var changeValue: (([String]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tagList = tagLabel.text?.split(separator: " ").map({ String($0) }) {
            changeValue?(tagList)
        }
    }
    
    override func configureHierarchy() {
        
        view.addSubview(tagTextField)
        view.addSubview(addButton)
        view.addSubview(tagLabel)
    }
    
    override func configureUI() {
        
        tagTextField.placeholder = "태그를 입력해주세요"
        tagTextField.layer.cornerRadius = 8
        tagTextField.backgroundColor = .cell
        tagTextField.autocorrectionType = .no
        tagTextField.spellCheckingType = .no
        tagTextField.delegate = self
        tagTextField.addLeftPadding()
        
        addButton.setTitle("추가", for: .normal)
        addButton.layer.cornerRadius = 8
        addButton.backgroundColor = .cell
        
        tagLabel.text = ""
        tagLabel.fontType(what: .listTag)
        tagLabel.numberOfLines = .zero
        
    }
    
    override func configureLayout() {
        
        tagTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(44)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(tagTextField.snp.trailing).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func configureGestureAndButtonAction() {
        
        addButton.addTarget(self,
                            action: #selector(addTag),
                            for: .touchUpInside)
    }
    
    @objc private func addTag() {
        
        if let text = tagTextField.text,
            !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            tagLabel.text! += " #\(text)"
            tagTextField.text = .none
        }
        
    }
}

extension TagEnrollViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTag()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
}
