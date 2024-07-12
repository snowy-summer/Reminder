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
    
    private let viewModel = EnrollViewModel()
    
    private let photoManager = PhotoManager()
    private var cancellables = Set<AnyCancellable>()
    
    convenience init(todo: Todo, type: EnrollVCModel.EnrollType) {
        self.init(nibName: nil, bundle: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingOutput()
        
    }
    
    // MARK: - Configuration
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
        super.configureUI()
        
        enrollTableView.delegate = self
        enrollTableView.dataSource = self
        enrollTableView.sectionHeaderHeight = 16
        enrollTableView.sectionFooterHeight = .zero
        
        enrollTableView.register(TitleAndMemoTableViewCell.self,
                                 forCellReuseIdentifier: TitleAndMemoTableViewCell.identifier)
        
        enrollTableView.register(EnrollInformationTitleTableViewCell.self,
                                 forCellReuseIdentifier: EnrollInformationTitleTableViewCell.identifier)
        enrollTableView.register(DatePickerTableViewCell.self,
                                 forCellReuseIdentifier: DatePickerTableViewCell.identifier)
        enrollTableView.register(TagListTableViewCell.self,
                                 forCellReuseIdentifier: TagListTableViewCell.identifier)
        
    }
    
    override func configureLayout() {
        
        enrollTableView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
}

//MARK: - EnrollVC private, @objc
extension EnrollViewController {
    
    private func bindingOutput() {
        
        viewModel.$canSave.sink { [weak self] canSave in
            guard let self = self else { return }
            
            navigationItem.rightBarButtonItem?.isEnabled = canSave ? true : false
        }.store(in: &cancellables)
        
        viewModel.$isDateExpand.sink { [weak self] isExpand in
            guard let self = self else { return }
            
            enrollTableView.reloadSections(IndexSet(integer: EnrollSections.deadLine.rawValue),
                                           with: .automatic)
        }.store(in: &cancellables)
        
        viewModel.$isTagExpand.sink { [weak self] isExpand in
            guard let self = self else { return }
            
            enrollTableView.reloadSections(IndexSet(integer: EnrollSections.tag.rawValue),
                                           with: .automatic)
        }.store(in: &cancellables)
    }
    
    @objc private func cancelButtonAction() {
        
        //        if model.type == .create {
        //            dismiss(animated: true)
        //        } else {
        //            navigationController?.popViewController(animated: true)
        //        }
        
        dismiss(animated: true)
    }
    
    @objc private func saveButtonAction() {
        
        viewModel.applyInput(.saveTodo)
        //        model.saveTodo()
        //
        //        if model.type == .create {
        //            dismiss(animated: true) {
        //                NotificationCenter.default.post(name: .updateHomeNotification, object: nil)
        //                NotificationCenter.default.post(name: .pushNotification, object: nil)
        //            }
        //        } else {
        //            navigationController?.popViewController(animated: true)
        //        }
    }
    
}

//MARK: - TableView Delegate, DataSource
extension EnrollViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        switch EnrollSections(rawValue: section) {
        case .main:
            return 2
        case .deadLine:
            return viewModel.isDateExpand ? 2 : 1
        case .tag:
            return viewModel.isTagExpand ? 2 : 1
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
            
            return UITableView.automaticDimension
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
                cell.updateContent(text: viewModel.todo.title)
            case .memo:
                cell.updateContent(text: viewModel.todo.subTitle)
            }
            
            
            return cell
            
        case .deadLine:
            
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollInformationTitleTableViewCell.identifier,
                                                               for: indexPath) as? EnrollInformationTitleTableViewCell,
                      let type = EnrollSections(rawValue: indexPath.section) else {
                    
                    return EnrollInformationTitleTableViewCell()
                }
                
                cell.viewModel = viewModel
                cell.updateContent(type: type, isExpand: viewModel.isDateExpand)
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.identifier,
                                                               for: indexPath) as? DatePickerTableViewCell else {
                    
                    return DatePickerTableViewCell()
                }
                
                return cell
            }
            
        case .tag:
            
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollInformationTitleTableViewCell.identifier,
                                                               for: indexPath) as? EnrollInformationTitleTableViewCell,
                      let type = EnrollSections(rawValue: indexPath.section) else {
                    
                    return EnrollInformationTitleTableViewCell()
                }
                
                cell.viewModel = viewModel
                cell.updateContent(type: type, isExpand: viewModel.isTagExpand)
                
                return cell
                
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TagListTableViewCell.identifier,
                                                               for: indexPath) as? TagListTableViewCell else {
                    
                    return TagListTableViewCell()
                }
                
                let tags = Array(viewModel.todo.tag)
                cell.updateContent(tags: tags)
                return cell
            }
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TagListTableViewCell.identifier,
                                                           for: indexPath) as? TagListTableViewCell,
                  let type = EnrollSections(rawValue: indexPath.section) else {
                
                return TagListTableViewCell()
            }
        
            return cell
            
        }
        
    }
    
}

extension EnrollViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {
        
        //        if let itemProvider = results.first?.itemProvider,
        //           itemProvider.canLoadObject(ofClass: UIImage.self) {
        //
        //            itemProvider.loadObject(ofClass: UIImage.self) {[weak self] image, error in
        //
        //                self?.model.photoImage = image as? UIImage
        //            }
        //        }
        //
        //        dismiss(animated: true)
    }
    
}

//MARK: - TitleAndMemoTableViewCellDelegate
extension EnrollViewController: TitleAndMemoTableViewCellDelegate {
    
    func changeSaveButtonEnabled(text: String, type: EnrollSections.Main) {
        
        if !text.isEmpty && text != type.text {
            
            switch type {
            case .title:
                viewModel.todo.title = text
                navigationItem.rightBarButtonItem?.isEnabled = true
                
            case .memo:
                viewModel.todo.subTitle = text
            }
            
        } else {
            
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
    }
}
