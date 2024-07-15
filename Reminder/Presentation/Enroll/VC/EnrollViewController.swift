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
    private var cancellables = Set<AnyCancellable>()
    var reloadView: (() -> Void)?
    
    init(reloadView: @escaping (() -> Void)) {
        
        self.reloadView = reloadView
        super.init(nibName: nil, bundle: nil)
    }
    
   convenience init(todo: Todo,
                    reloadView: @escaping (() -> Void)) {
       self.init(reloadView: reloadView)
        
        viewModel.applyInput(.loadTodo(todo))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        navigationController?.navigationBar.backgroundColor = viewModel.isEditMode ? .base : .modalBackground
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
        enrollTableView.register(PriorityTableViewCell.self,
                                 forCellReuseIdentifier: PriorityTableViewCell.identifier)
        enrollTableView.register(TagListTableViewCell.self,
                                 forCellReuseIdentifier: TagListTableViewCell.identifier)
        enrollTableView.register(ImageListTableViewCell.self,
                                 forCellReuseIdentifier: ImageListTableViewCell.identifier)
        
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
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                enrollTableView.reloadSections(IndexSet(integer: EnrollSections.deadLine.rawValue),
                                               with: .automatic)
            }.store(in: &cancellables)
        
        viewModel.$isTagExpand.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                enrollTableView.reloadSections(IndexSet(integer: EnrollSections.tag.rawValue),
                                               with: .automatic)
            }.store(in: &cancellables)
        
        viewModel.$priority.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                enrollTableView.reloadSections(IndexSet(integer: EnrollSections.priority.rawValue),
                                               with: .automatic)
            }.store(in: &cancellables)
        
        viewModel.$imageList.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                enrollTableView.reloadSections(IndexSet(integer: EnrollSections.addImage.rawValue),
                                               with: .automatic)
            }.store(in: &cancellables)
    }
    
    @objc private func cancelButtonAction() {
        
        if viewModel.isEditMode {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc private func saveButtonAction() {
        
        viewModel.applyInput(.saveTodo)
        
        if viewModel.isEditMode {
            reloadView?()
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true) { [weak self] in
                self?.reloadView?()
            }
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
            return viewModel.imageList.count + 1
            
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
            
        case .addImage:
            
            return 60
            
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
            
        case .priority:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PriorityTableViewCell.identifier,
                                                           for: indexPath) as? PriorityTableViewCell else {
                
                return PriorityTableViewCell()
            }
            
            cell.viewModel = viewModel
            cell.updateContent()
            
            return cell
            
        case .addImage:
            
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollInformationNoneSwitchCell.identifier,
                                                               for: indexPath) as? EnrollInformationNoneSwitchCell,
                      let type = EnrollSections(rawValue: indexPath.section) else {
                    
                    return EnrollInformationNoneSwitchCell()
                }
                
                cell.viewModel = viewModel
                cell.updateContent(type: type, content: nil)
                
                return cell
                
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageListTableViewCell.identifier,
                                                               for: indexPath) as? ImageListTableViewCell else {
                    
                    return ImageListTableViewCell()
                }
                
                let data = viewModel.imageList[indexPath.row - 1]
                cell.updateContent(name: data)
                
                return cell
            }
            
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
            
            if indexPath.row == 0 {
                var configuration = PHPickerConfiguration()
                configuration.filter = .images
                configuration.selectionLimit = 4
                
                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = self
                present(picker, animated: true)
                
                return
                
            } else {
                viewModel.applyInput(.removeImage(indexPath.row - 1))
            }
            
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
                    
                    viewModel.applyInput(.appendImage(image))
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
                viewModel.applyInput(.updateTitle(text))
                navigationItem.rightBarButtonItem?.isEnabled = true
                
            case .memo:
                viewModel.applyInput(.updateSubTitle(text))
            }
            
        } else {
            
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
    }
}
