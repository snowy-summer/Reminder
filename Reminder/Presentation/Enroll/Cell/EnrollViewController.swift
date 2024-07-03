//
//  EnrollViewController.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

final class EnrollViewController: BaseViewController {
    
    private let enrollTableView = UITableView(frame: .zero,
                                              style: .insetGrouped)
    private let model = Todo(title: "")
    private var saveItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(DataBaseManager.shared.realm.configuration.fileURL)
    }
    
    override func configureNavigationBar() {
        
        let cancelItem = UIBarButtonItem(title: "취소",
                                         style: .plain,
                                         target: self,
                                         action: #selector(cancelButtonAction))
        
        saveItem = UIBarButtonItem(title: "저장",
                                   style: .plain,
                                   target: self,
                                   action: #selector(saveButtonAction))
        saveItem.isEnabled = false
        
        navigationItem.rightBarButtonItem = saveItem
        navigationItem.leftBarButtonItem = cancelItem
    }
    
    override func configureHierarchy() {
        view.addSubview(enrollTableView)
    }
    
    override func configureUI() {
        
        enrollTableView.delegate = self
        enrollTableView.dataSource = self
        enrollTableView.sectionHeaderHeight = 16
        enrollTableView.sectionFooterHeight = .zero
        
        enrollTableView.register(TitleAndMemoTableViewCell.self,
                                 forCellReuseIdentifier: TitleAndMemoTableViewCell.identifier)
        
        enrollTableView.register(EnrollExtraTableViewCell.self,
                                 forCellReuseIdentifier: EnrollExtraTableViewCell.identifier)
        
    }
    
    override func configureLayout() {
        
        enrollTableView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
}

//MARK: - EnrollVC private, @objc
extension EnrollViewController {
    
    @objc private func cancelButtonAction() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonAction() {
        
        DataBaseManager.shared.add(model)
        
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .pushNotification, object: nil)
        }
    }
    
}

//MARK: - TableView Delegate, DataSource
extension EnrollViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return EnrollSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        switch EnrollSections(rawValue: section) {
        case .main:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch EnrollSections(rawValue: indexPath.section) {
        case .main:
            if indexPath.row == 0 {
                return 44
            }
            
            return view.frame.height * 0.1
            
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch EnrollSections(rawValue: indexPath.section) {
        case .main:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleAndMemoTableViewCell.identifier,
                                                           for: indexPath) as? TitleAndMemoTableViewCell,
                  let type = EnrollSections.Main(rawValue: indexPath.row) else {
                
                return TitleAndMemoTableViewCell()
            }
            
            cell.delegate = self
            cell.type = type
            
            switch type {
            case .title:
                cell.updateContent(text: model.title)
            case .memo:
                cell.updateContent(text: model.subTitle)
            }
            
            
            return cell
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollExtraTableViewCell.identifier,
                                                           for: indexPath) as? EnrollExtraTableViewCell,
                  let type = EnrollSections(rawValue: indexPath.section) else {
                
                return EnrollExtraTableViewCell()
            }
            
            switch type {
                
            case .deadLine:
                var formattedDeadLine: String?
                if let deadLine = model.deadLine {
                    formattedDeadLine = DateManager.shared.formattedDate(date: deadLine)
                    
                }
                
                cell.updateContent(type: type,
                                   content: formattedDeadLine)
                
            case .tag:
                var text = ""
                for tag in model.tag {
                    text += "\(tag) "
                }
                
                cell.updateContent(type: type,
                                   content: text)
                
            case .priority:
                
                var priorityText: String?
                
                if let priority = model.priority,
                   let text = PriorityType(rawValue: priority)?.title {
                    
                    priorityText = text
                }
                
                cell.updateContent(type: type,
                                   content: priorityText)
                
            case .addImage:
                cell.updateContent(type: type,
                                   content: nil)
                
            default:
                break
            }
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal,
                                        title: "삭제") { action, view, completionHandler in
            let todo = DataBaseManager.shared.read(Todo.self)[indexPath.row]
            DataBaseManager.shared.delete(todo)
            tableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        switch EnrollSections(rawValue: indexPath.section) {
        case .deadLine:
            let vc = DeadLineEnrollViewController()
            vc.changeValue = { value in
                self.model.deadLine = value
                tableView.reloadData()
            }
            navigationController?.pushViewController(vc, animated: false)
            
        case .tag:
            let vc = TagEnrollViewController()
            vc.changeValue = { value in
                let list = List<String>()
                value.forEach { tag in
                    list.append(tag)
                }
                self.model.tag = list
                tableView.reloadData()
            }
            
            navigationController?.pushViewController(vc, animated: false)
            
        case .priority:
            let vc = PriorityEnrollViewController()
            vc.changeValue = { value in
                self.model.priority = value
                tableView.reloadData()
                
            }
            navigationController?.pushViewController(vc, animated: false)
            
        case .addImage:
            break
            
        default:
            break
        }
        
    }
    
}

extension EnrollViewController: TitleAndMemoTableViewCellDelegate {
    
    func changeSaveButtonEnabled(text: String, type: EnrollSections.Main) {
        
        if !text.isEmpty && text != type.text {
            
            switch type {
            case .title:
                model.title = text
            case .memo:
                model.subTitle = text
            }
            
            saveItem.isEnabled = true
        } else {
            saveItem.isEnabled = false
        }
        
    }
}
