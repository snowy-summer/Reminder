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
        navigationItem.title = "새로운 미리 알림"
        navigationController?.navigationBar.backgroundColor = .modalBackground
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
        enrollTableView.register(EnrollInformationNoneSwitchCell.self,
                                 forCellReuseIdentifier: EnrollInformationNoneSwitchCell.identifier)
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
        
        viewModel.$folder.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                enrollTableView.reloadRows(at: [IndexPath(row: 0,
                                                          section: EnrollSections.folder.rawValue)],
                                           with: .none)
            }.store(in: &cancellables)
        
        
        viewModel.$deadLine.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                enrollTableView.reloadRows(at: [IndexPath(row: 0,
                                                          section: EnrollSections.deadLine.rawValue)],
                                           with: .none)
            }.store(in: &cancellables)
        
        viewModel.$isDateExpand.receive(on: DispatchQueue.main)
            .sink { [weak self] isExpand in
                guard let self = self else { return }
                
                enrollTableView.reloadSections(IndexSet(integer: EnrollSections.deadLine.rawValue),
                                               with: .automatic)
            }.store(in: &cancellables)
        
        viewModel.$isTagExpand.receive(on: DispatchQueue.main)
            .sink { [weak self] isExpand in
                guard let self = self else { return }
                
                enrollTableView.reloadSections(IndexSet(integer: EnrollSections.tag.rawValue),
                                               with: .automatic)
            }.store(in: &cancellables)
        
    }
    
    @objc private func cancelButtonAction() {
        
        dismiss(animated: true)
    }
    
    @objc private func saveButtonAction() {
        
        viewModel.applyInput(.saveTodo)
        dismiss(animated: true)
    }
    
}

//MARK: - TableView Delegate, DataSource
extension EnrollViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return EnrollSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        let sectionType = EnrollSections(rawValue: section)
        switch sectionType {
        case .main:
            return 2
            
        case .folder:
            return 1
            
        case .deadLine:
            return viewModel.isDateExpand ? 2 : 1
            
        case .tag:
            return viewModel.isTagExpand ? 2 : 1
            
        case .pin:
            return 1
            
        case .priority:
            return 1
            
        case .addImage:
            return 1
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch EnrollSections(rawValue: indexPath.section) {
        case .main:
            if indexPath.row == 0 {
                return 44
            }
            
            return view.frame.height * 0.1
            
        case .tag:
            
            if indexPath.row == 0 {
                return 60
            }
            
            return view.frame.height * 0.3
            
        default:
            
            if indexPath.row == 0 {
                return 60
            }
            
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
            
        case .folder:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollInformationNoneSwitchCell.identifier,
                                                           for: indexPath) as? EnrollInformationNoneSwitchCell,
                  let type = EnrollSections(rawValue: indexPath.section) else {
                
                return EnrollInformationNoneSwitchCell()
            }
            
            cell.viewModel = viewModel
            cell.updateContent(type: type, content: viewModel.folder?.name)
            
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
                
                cell.viewModel = viewModel
                
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
                
                cell.viewModel = viewModel
                cell.bindingOutput()
                
                return cell
            }
            
        case .addImage:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollInformationNoneSwitchCell.identifier,
                                                           for: indexPath) as? EnrollInformationNoneSwitchCell,
                  let type = EnrollSections(rawValue: indexPath.section) else {
                
                return EnrollInformationNoneSwitchCell()
            }
            
            cell.viewModel = viewModel
            cell.updateContent(type: type, content: nil)
            
            return cell
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollInformationTitleTableViewCell.identifier,
                                                           for: indexPath) as? EnrollInformationTitleTableViewCell,
                  let type = EnrollSections(rawValue: indexPath.section) else {
                
                return EnrollInformationTitleTableViewCell()
            }
            
            cell.viewModel = viewModel
            cell.updateContent(type: type, isExpand: viewModel.isDateExpand)
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = EnrollSections(rawValue: indexPath.section) else { return }
        
        switch section {
            
        case .folder:
            let vc = FolderListViewController { [weak self] folder in
                
                self?.viewModel.applyInput(.updateFolder(folder))
            }
            
            navigationController?.pushViewController(vc, animated: true)
            return
            
        case .addImage:
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            configuration.selectionLimit = 4
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            present(picker, animated: true)
            
            return
            
        default:
            return
        }
    }
}
extension EnrollViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {
        
        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                
                itemProvider.loadObject(ofClass: UIImage.self) {[weak self] image, error in
                    guard let self = self,
                          let image = image as? UIImage else { return }
                    
                    viewModel.imageList.append(image)
                }
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