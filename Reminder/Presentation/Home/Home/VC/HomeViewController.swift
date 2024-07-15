//
//  HomeViewController.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit
import Combine
import SnapKit

final class HomeViewController: BaseViewController {
    
    private let searchResultTableView = UITableView()
    private lazy var homeCollectionView = UICollectionView(frame: .zero,
                                                           collectionViewLayout: createCollectionViewLayout())
    private let searchBar = UISearchBar()
    
    private let viewModel = HomeViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNotification()
        configureToolBar()
        
        bindOutPut()
        viewModel.applyUserInput(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        homeCollectionView.reloadData()
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .updateHomeNotification,
                                                  object: nil)
    }
    
    //MARK: - Configuration
    override func configureNavigationBar() {
        
        let calendarItem = UIBarButtonItem(image: UIImage(systemName: "calendar"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(showCalendar))
        
        let undoItem = UIBarButtonItem(image: UIImage(systemName:"arrow.counterclockwise"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(showTableOrCollectionView))
        
        navigationItem.leftBarButtonItem = calendarItem
        navigationItem.rightBarButtonItem = undoItem
        
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
    }
    
    override func configureHierarchy() {
        
        view.addSubview(homeCollectionView)
        view.addSubview(searchResultTableView)
    }
    
    override func configureUI() {
        super.configureUI()
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        
        homeCollectionView.register(HomeDefaultListTypeCell.self,
                                    forCellWithReuseIdentifier: HomeDefaultListTypeCell.identifier)
        homeCollectionView.register(HomeCustomFolderTypeCell.self,
                                    forCellWithReuseIdentifier: HomeCustomFolderTypeCell.identifier)
        
        homeCollectionView.register(HomeHeaderView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: HomeHeaderView.identifier)
        
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        searchResultTableView.isHidden = true
        
        searchResultTableView.register(ListTableViewCell.self,
                                       forCellReuseIdentifier: ListTableViewCell.identifier)
        
    }
    
    override func configureLayout() {
        
        homeCollectionView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchResultTableView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureToolBar() {
        
        navigationController?.isToolbarHidden = false
        
        let addTodoButton = UIButton()
        addTodoButton.toolBarButtonItem(type: .addTodo)
        addTodoButton.addTarget(self,
                                action: #selector(addTodo),
                                for: .touchUpInside)
        
        
        
        let addTodoItem = UIBarButtonItem(customView: addTodoButton)
        
        let addListItem = UIBarButtonItem(title: ToolBarButtonType.addList.title,
                                          style: .plain,
                                          target: self,
                                          action: #selector(addList))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace,
                                         target: nil,
                                         action: nil)
        fixedSpace.width = -16
        
        toolbarItems = [
            fixedSpace,
            addTodoItem,
            flexibleSpace,
            addListItem
        ]
        
    }
    
    private func configureNotification() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(addCustomFolder),
                                               name: .updateHomeNotification,
                                               object: nil)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let collectioViewCompositonalLayout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            switch HomeCollectionViewSection(rawValue: sectionIndex) {
                
            case .defaultList:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8,
                                                             leading: 8,
                                                             bottom: 8,
                                                             trailing: 8)
                
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(0.15))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 16,
                                                                leading: 16,
                                                                bottom: 16,
                                                                trailing: 16)
                return section
                
            case .customList:
                var layoutConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                
                layoutConfiguration.trailingSwipeActionsConfigurationProvider = { indexPath in
                    
                    
                    let deleteAction = UIContextualAction(style: .normal,
                                                          title: nil) { [weak self] action, view, completion in
                        guard let self = self else { return }
                        
                        viewModel.applyUserInput(.deleteCustomFolder(indexPath.row))
                        
                    }
                    
                    deleteAction.image = UIImage(systemName: "trash.fill")
                    deleteAction.backgroundColor = .red
                    
                    let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
                    configuration.performsFirstActionWithFullSwipe = false
                    
                    return configuration
                }
                
                return .list(using: layoutConfiguration,
                             layoutEnvironment: layoutEnvironment)
                
            default:
                return nil
            }
        }
        
        return collectioViewCompositonalLayout
    }
}

//MARK: - Method
extension HomeViewController {
    
    private func bindOutPut() {
        
        viewModel.$customFolderList.receive(on:DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                homeCollectionView.reloadSections(IndexSet(integer: HomeCollectionViewSection.customList.rawValue))
            }.store(in: &cancellable)
        
        viewModel.$searhResultList.receive(on:DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                
                guard let _ = value else {
                    searchResultTableView.isHidden = true
                    homeCollectionView.isHidden = false
                    return
                }
                
                searchResultTableView.isHidden = false
                homeCollectionView.isHidden = true
                searchResultTableView.reloadData()
                
            }.store(in: &cancellable)
        
    }
    
    @objc private func addCustomFolder() {
        
        viewModel.applyUserInput(.addNewCustomFolder)
    }
    
    @objc private func addTodo() {
        
        let nv = UINavigationController(rootViewController: EnrollViewController() { [weak self] in
            self?.homeCollectionView.reloadData()
        })
        
        present(nv, animated: true)
    }
    
    @objc private func addList() {
        
        
        let nv = UINavigationController(rootViewController: AddFolderViewController())
        present(nv, animated: true)
    }
    
    @objc private func showCalendar() {
        
        let vc = CalendarModal()
        vc.modalPresentationStyle = .pageSheet
        vc.showFilteredResult = { [weak self] value in
            self?.viewModel.applyUserInput(.filteredDate(value))
        }
        if let sheet = vc.sheetPresentationController {
            
            sheet.detents = [.medium(), .large()]
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
        }
        
        present(vc, animated: true)
    }
    
    @objc private func showTableOrCollectionView() {
        
        homeCollectionView.isHidden.toggle()
        searchResultTableView.isHidden.toggle()
    }
    
}

//MARK: - CollectionView Delegate, DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeCollectionViewSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        switch HomeCollectionViewSection(rawValue: section) {
        case .defaultList:
            return HomeFilteredFolderCellType.allCases.count
            
        case .customList:
            return viewModel.customFolderList.count
            
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch HomeCollectionViewSection(rawValue: indexPath.section) {
        case .defaultList:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDefaultListTypeCell.identifier,
                                                                for: indexPath) as? HomeDefaultListTypeCell
            else {
                
                return HomeDefaultListTypeCell()
            }
            
            if let cellType = HomeFilteredFolderCellType(rawValue: indexPath.row) {
                
                cell.updateContent(type: cellType)
            }
            
            return cell
            
        case .customList:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCustomFolderTypeCell.identifier,
                                                                for: indexPath) as? HomeCustomFolderTypeCell
            else {
                
                return HomeCustomFolderTypeCell()
            }
            
            let data = viewModel.customFolderList[indexPath.row]
            cell.updateContent(data: data)
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                           withReuseIdentifier: HomeHeaderView.identifier,
                                                                           for: indexPath) as? HomeHeaderView else {
            return HomeHeaderView()
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
        
            if let type = HomeFilteredFolderCellType(rawValue: indexPath.row) {
                
                navigationController?.pushViewController(ListViewController(data: Array(type.data),
                                                                            name: type.title,
                                                                            color: type.iconTintColor),
                                                         animated: true)
            }
        } else {
            let data = viewModel.customFolderList[indexPath.row]
            let color = UIColor(red: data.redColor,
                                green: data.greenColor,
                                blue: data.blueColor,
                                alpha: 1.0)
            navigationController?.pushViewController(ListViewController(data: Array(data.todoList),
                                                                        name: data.name,
                                                                        color: color),
                                                     animated: true)
        }
    }
}

//MARK: - TableViewDelegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.searhResultList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier,
                                                       for: indexPath) as? ListTableViewCell else {
            return ListTableViewCell()
        }
        
        if let data = viewModel.searhResultList?[indexPath.row] {
            cell.updateContent(data: data)
        }
        
        
        return cell
    }
    
}

//MARK: - SearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        viewModel.applyUserInput(.searchTodo(searchText))
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        viewModel.applyUserInput(.searchTodo(nil))
    }
    
}
