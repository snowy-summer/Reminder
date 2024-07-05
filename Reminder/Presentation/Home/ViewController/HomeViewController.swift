//
//  HomeViewController.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

final class HomeViewController: BaseViewController {
    
    private let searchResultTableView = UITableView()
    private lazy var homeCollectionView = UICollectionView(frame: .zero,
                                                           collectionViewLayout: createCollectionViewLayout())
    private let searchBar = UISearchBar()
    private var searchModel: Results<Todo>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNotification()
        configureToolBar()
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
                                                  name: .updateNotification,
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
        
        homeCollectionView.register(HomeCollectionViewCell.self,
                                    forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
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
                                               name: .updateNotification,
                                               object: nil)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout{
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: 8,
                                           bottom: 0,
                                           right: 8)
        layout.scrollDirection = .vertical
        
        let width = (view.frame.width - 32) / 2
        let height = view.frame.height * 0.1
        layout.itemSize = CGSize(width: width,
                                 height: height)
        
        layout.headerReferenceSize = CGSize(width: view.frame.width,
                                            height: height)
        
        return layout
    }
}

//MARK: - Method
extension HomeViewController {
    
    @objc private func updateCollectionView() {
        
        homeCollectionView.reloadData()
    }
    
    @objc private func pushListViewController() {
        
        let vc = ListViewController(data: HomeCollectionViewCellType.all.data,
                                    type: .all)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func addTodo() {
        
        let nv = UINavigationController(rootViewController: EnrollViewController())
        nv.modalPresentationStyle = .fullScreen
        
        present(nv,
                animated: true)
    }
    
    @objc private func addList() {
        
        let vc = ListViewController(data: HomeCollectionViewCellType.all.data,
                                    type: .all)
        
        navigationController?.pushViewController(vc, animated: true)
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
        searchResultTableView.isHidden.toggle()
        homeCollectionView.isHidden.toggle()
    }
    
    private func showFilteredResult(date: Date) {
        
        let dateString = DateManager.shared.formattedDate(date: date)
        
        let searchedData = DataBaseManager.shared.read(Todo.self).where {

            $0.deadLine == date
        }
        
        showTableOrCollectionView()
        searchModel = searchedData
        
        searchResultTableView.reloadData()
    }
}

//MARK: - CollectionView Delegate, DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return HomeCollectionViewCellType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier,
                                                            for: indexPath) as? HomeCollectionViewCell,
              let cellType = HomeCollectionViewCellType(rawValue: indexPath.row) else {
            
            return HomeCollectionViewCell()
        }
        
        
        cell.updateContent(type: cellType)
        
        return cell
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
        
        if let data = HomeCollectionViewCellType(rawValue: indexPath.row)?.data {
            
            navigationController?.pushViewController(ListViewController(data: data,
                                                                        type: HomeCollectionViewCellType(rawValue: indexPath.row)!), animated: true)
        }
    }
}

//MARK: - TableViewDelegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier,
                                                       for: indexPath) as? ListTableViewCell else {
            return ListTableViewCell()
        }
        
        if let searchModel = searchModel {
            let data = searchModel[indexPath.row]
            cell.updateContent(data: data)
        }
        
        
        return cell
    }
    
}

//MARK: - SearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchedData = DataBaseManager.shared.read(Todo.self).where {
            $0.title.contains(searchText, options: .caseInsensitive) ||
            $0.subTitle.contains(searchText, options: .caseInsensitive)
        }
        
        if searchText.isEmpty {
            showTableOrCollectionView()
            searchModel = nil
        } else {
            showTableOrCollectionView()
            searchModel = searchedData
        }
        
        searchResultTableView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
       showTableOrCollectionView()
        
    }
    
}
