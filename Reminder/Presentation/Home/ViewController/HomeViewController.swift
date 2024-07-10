//
//  HomeViewController.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit
import Combine
import SnapKit
import RealmSwift

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
        
        configureNavigationBar()
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .pushNotification,
                                                  object: nil)
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
        homeCollectionView.register(HomeCustomListTypeCell.self,
                                    forCellWithReuseIdentifier: HomeCustomListTypeCell.identifier)
        
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
                                               selector: #selector(pushListViewController),
                                               name: .pushNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateCollectionView),
                                               name: .updateHomeNotification,
                                               object: nil)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let collectioViewCompositonalLayout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            
            return HomeCollectionViewSection(rawValue: sectionIndex)?.layoutSection(environment: layoutEnvironment)
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
            
            guard let value = value else {
                searchResultTableView.isHidden = true
                homeCollectionView.isHidden = false
                return
            }
            
                searchResultTableView.isHidden = false
                homeCollectionView.isHidden = true
                searchResultTableView.reloadData()
        
        }.store(in: &cancellable)
        
    }
    
    @objc private func updateCollectionView() {
        
        homeCollectionView.reloadData()
    }
    
    @objc private func pushListViewController() {
        
        let vc = ListViewController(data: HomeFilteredFolderCellType.all.data,
                                    type: .all)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func addTodo() {
        
        let nv = UINavigationController(rootViewController: EnrollViewController())
        nv.modalPresentationStyle = .fullScreen
        
        present(nv, animated: true)
    }
    
    @objc private func addList() {
        
        
        let nv = UINavigationController(rootViewController: AddFolderViewController())
        nv.modalPresentationStyle = .fullScreen
        
        present(nv, animated: true)
    }
    
    @objc private func showCalendar() {
        
        let vc = CalendarModal()
        vc.modalPresentationStyle = .pageSheet
        vc.showFilteredResult = { [weak self] value in
            self?.showFilteredResult(date: value)
        }
        if let sheet = vc.sheetPresentationController {
            
            sheet.detents = [.medium(), .large()]
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
        }
        
        present(vc, animated: true)
    }
    
    @objc private func showTableOrCollectionView() {
        //        searchResultTableView.isHidden.toggle()
        //        homeCollectionView.isHidden.toggle()
    }
    //
    private func showFilteredResult(date: Date) {
        
        //        let calendar = Calendar.current
        //        let yesterday = calendar.date(byAdding: .day, value: -1, to: date)!
        //        let tomorrow = calendar.date(byAdding: .day, value: 1, to: date)!
        //
        //        let searchedData = DataBaseManager.shared.read(Todo.self).where {
        //            $0.deadLine >= yesterday && $0.deadLine <= tomorrow
        //        }
        //
        //        showTableOrCollectionView()
        //        searchModel = searchedData
        //
        //        searchResultTableView.reloadData()
        
        
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
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCustomListTypeCell.identifier,
                                                                for: indexPath) as? HomeCustomListTypeCell
            else {
                
                return HomeCustomListTypeCell()
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
        
        if let data = HomeFilteredFolderCellType(rawValue: indexPath.row)?.data {
            
            navigationController?.pushViewController(ListViewController(data: data,
                                                                        type: HomeFilteredFolderCellType(rawValue: indexPath.row)!),
                                                     animated: true)
        } else {
            //            let data = folderList[indexPath.row - HomeFilteredFolderCellType.allCases.count]
            //            navigationController?.pushViewController(ExtraTodoInFolderViewController(data: data),
            //                                                     animated: true)
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
