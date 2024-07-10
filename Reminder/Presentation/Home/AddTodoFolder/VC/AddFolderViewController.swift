//
//  AddFolderViewController.swift
//  Reminder
//
//  Created by 최승범 on 7/8/24.
//

import UIKit
import SnapKit

final class AddFolderViewController: BaseViewController {
    
    private let addTableView = UITableView(frame: .zero,
                                           style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureNavigationBar() {
        
        let saveItem = UIBarButtonItem(title: "완료",
                                       style: .plain,
                                       target: self,
                                       action: #selector(saveFolder))
        
        let dismissItem = UIBarButtonItem(title: "취소",
                                       style: .plain,
                                       target: self,
                                       action: #selector(dismissVC))
        
        
        navigationItem.rightBarButtonItem = saveItem
        navigationItem.leftBarButtonItem = dismissItem
        navigationItem.title = "새로운 목록"
        navigationController?.navigationBar.backgroundColor = .modalBackground
    }
    
    override func configureHierarchy() {
        
        view.addSubview(addTableView)
    }
    
    override func configureUI() {
        super.configureUI()
        
        view.backgroundColor = .modalBackground
        
        addTableView.delegate = self
        addTableView.dataSource = self
        
        addTableView.register(TitleSectionCell.self,
                              forCellReuseIdentifier: TitleSectionCell.identifier)
        addTableView.register(ColorSectionCell.self,
                              forCellReuseIdentifier: ColorSectionCell.identifier)
        addTableView.register(IconSectionCell.self,
                              forCellReuseIdentifier: IconSectionCell.identifier)
        
    }
    
    override func configureLayout() {
        
        addTableView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

//MARK: - Method
extension AddFolderViewController {
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc private func saveFolder() {
        
        
        dismiss(animated: true)
        
    }
}

//MARK: - TableView Delegate, Datasource
extension AddFolderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return AddFolderSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height = view.frame.height
        
        switch AddFolderSection(rawValue: indexPath.section) {
        case .title:
            return height * 0.24
            
        case .selectColor:
            return height * 0.16
            
        case .selectIcon:
            return height * 0.36
            
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch AddFolderSection(rawValue: indexPath.section) {
        case .title:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleSectionCell.identifier,
                                                           for: indexPath) as? TitleSectionCell else {
                return TitleSectionCell()
            }
            
            return cell
            
        case .selectColor:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ColorSectionCell.identifier,
                                                           for: indexPath) as? ColorSectionCell else {
                return ColorSectionCell()
            }
            
            return cell
            
        case .selectIcon:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: IconSectionCell.identifier,
                                                           for: indexPath) as? IconSectionCell else {
                return IconSectionCell()
            }
            
            return cell
            
        default:
            return UITableViewCell()
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { .leastNormalMagnitude
    }
    
}