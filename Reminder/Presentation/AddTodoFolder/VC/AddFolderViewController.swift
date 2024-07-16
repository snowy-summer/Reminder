//
//  AddFolderViewController.swift
//  Reminder
//
//  Created by 최승범 on 7/8/24.
//

import UIKit
import Combine
import SnapKit

final class AddFolderViewController: BaseViewController {
    
    private let addTableView = UITableView(frame: .zero,
                                           style: .insetGrouped)
    private var saveButtonItem: UIBarButtonItem!
    
    private let viewModel = AddFolderViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindingOutput()
    }
    
    override func configureNavigationBar() {
        
        saveButtonItem = UIBarButtonItem(title: "완료",
                                         style: .plain,
                                         target: self,
                                         action: #selector(saveFolder))
        saveButtonItem.isEnabled = false
        
        let dismissItem = UIBarButtonItem(title: "취소",
                                          style: .plain,
                                          target: self,
                                          action: #selector(dismissVC))
        
        
        navigationItem.rightBarButtonItem = saveButtonItem
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
    
    private func bindingOutput() {
        
        viewModel.$folderName.sink { [weak self] newFolderName in
            guard let self = self else { return }
            
            if newFolderName != nil {
                saveButtonItem.isEnabled = true
            } else {
                saveButtonItem.isEnabled = false
            }
        }.store(in: &cancellable)
        
        viewModel.$iconColor.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
            guard let self = self else { return }
            
            addTableView.reloadSections(IndexSet(integer: AddFolderSection.title.rawValue),
                                        with: .none)
            
        }.store(in: &cancellable)
        
        viewModel.$iconName.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
            guard let self = self else { return }
            
            addTableView.reloadSections(IndexSet(integer: AddFolderSection.title.rawValue),
                                        with: .none)
        }.store(in: &cancellable)
    }
    
    @objc private func dismissVC() {
        
        dismiss(animated: true)
    }
    
    @objc private func saveFolder() {
        
        viewModel.applyUserInput(.saveFolder)
        dismiss(animated: true) {
            NotificationCenter.default.post(name: .updateHomeNotification, object: nil)
        }
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
            return  height * 0.3
            
        case .selectColor:
            return height * 0.2
            
        case .selectIcon:
            return height * 0.45
            
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
            
            cell.texFieldChanged = { [weak self] textValue in
                guard let self = self else { return }

                viewModel.applyUserInput(.writeFolderName(folderName: textValue))
            }
            
            cell.updateContent(folderName: viewModel.folderName,
                               iconName: viewModel.iconName,
                               color: viewModel.iconColor)
            
            return cell
            
        case .selectColor:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ColorSectionCell.identifier,
                                                           for: indexPath) as? ColorSectionCell else {
                return ColorSectionCell()
            }
            
            cell.changeColor = {[weak self] newValue in
                guard let self = self else { return }
                viewModel.applyUserInput(.selectColor(index: newValue))
            }
            
            return cell
            
        case .selectIcon:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: IconSectionCell.identifier,
                                                           for: indexPath) as? IconSectionCell else {
                return IconSectionCell()
            }
            
            cell.changeIcon = {[weak self] newValue in
                guard let self = self else { return }
                viewModel.applyUserInput(.selectIcon(index: newValue))
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
