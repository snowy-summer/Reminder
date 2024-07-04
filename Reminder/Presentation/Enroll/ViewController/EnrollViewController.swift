//
//  EnrollViewController.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit
import Combine
import PhotosUI
import SnapKit

final class EnrollViewController: BaseViewController {
    
    private let enrollTableView = UITableView(frame: .zero,
                                              style: .insetGrouped)
    
    private var model = EnrollVCModel()
    private let photoManager = PhotoManager()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.$photoImage.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.enrollTableView.reloadData()
            }.store(in: &cancellables)
            
        }
    
    override func configureNavigationBar() {
        
        let cancelItem = UIBarButtonItem(title: "취소",
                                         style: .plain,
                                         target: self,
                                         action: #selector(cancelButtonAction))
        
        let saveItem = UIBarButtonItem(title: "저장",
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
        
        model.saveTodo()
        
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .updateNotification, object: nil)
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
                cell.updateContent(text: model.todo.title)
            case .memo:
                cell.updateContent(text: model.todo.subTitle)
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
                if let deadLine = model.todo.deadLine {
                    formattedDeadLine = DateManager.shared.formattedDate(date: deadLine)
                    
                }
                
                cell.updateContent(type: type,
                                   content: formattedDeadLine)
                
            case .tag:
                var text = model.changeListToTags().joined(separator: " ")
                
                cell.updateContent(type: type,
                                   content: text)
                
            case .priority:
                
                var priorityText: String?
                
                if let priority = model.todo.priority,
                   let text = PriorityType(rawValue: priority)?.title {
                    
                    priorityText = text
                }
                
                cell.updateContent(type: type,
                                   content: priorityText)
                
            case .addImage:
                cell.updateContent(imageContent: model.photoImage)
                
            default:
                break
            }
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        switch EnrollSections(rawValue: indexPath.section) {
        case .deadLine:
            let vc = DeadLineEnrollViewController(value: model.todo.deadLine)
            vc.changeValue = { [weak self] value in
                self?.model.todo.deadLine = value
                tableView.reloadData()
            }
            navigationController?.pushViewController(vc, animated: false)
            
        case .tag:
            let vc = TagEnrollViewController(value: model.changeListToTags() )
            vc.changeValue = { [weak self] value in
                self?.model.changeTagsToList(value: value)
                tableView.reloadData()
            }
            navigationController?.pushViewController(vc, animated: false)
            
        case .priority:
            let vc: PriorityEnrollViewController
            if model.todo.priority == PriorityType.no.rawValue {
                vc = PriorityEnrollViewController(value: nil)
            } else {
                vc = PriorityEnrollViewController(value: model.todo.priority)
            }
            
            vc.changeValue = { [weak self] value in
                self?.model.todo.priority = value
                tableView.reloadData()
                
            }
            navigationController?.pushViewController(vc, animated: false)
            
        case .addImage:
            var config = PHPickerConfiguration()
            config.filter = .images
            config.selectionLimit = 1
            
            let vc = PHPickerViewController(configuration: config)
            vc.delegate = self
            
            present(vc, animated: true)
            
        default:
            break
        }
        
    }
    
}

extension EnrollViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {
        
        if let itemProvider = results.first?.itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            
            itemProvider.loadObject(ofClass: UIImage.self) {[weak self] image, error in
                
                self?.model.photoImage = image as? UIImage
            }
        }
        
        dismiss(animated: true)
    }
    
}

//MARK: - TitleAndMemoTableViewCellDelegate
extension EnrollViewController: TitleAndMemoTableViewCellDelegate {
    
    func changeSaveButtonEnabled(text: String, type: EnrollSections.Main) {
        
        if !text.isEmpty && text != type.text {
            
            switch type {
            case .title:
                model.todo.title = text
                navigationItem.rightBarButtonItem?.isEnabled = true
                
            case .memo:
                model.todo.subTitle = text
            }
            
        } else {
            
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
    }
}
