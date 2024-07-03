//
//  HomeViewController.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit
import SnapKit

final class HomeViewController: BaseViewController {
    
    private lazy var homeCollectionView = UICollectionView(frame: .zero,
                                                           collectionViewLayout: createCollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNotification()
        configureToolBar()
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .pushNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .updateNotification,
                                                  object: nil)
    }
    
    override func configureNavigationBar() {
        
        let moreItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                       menu: configureMenu())
        
        navigationItem.rightBarButtonItem = moreItem
    }
    
    override func configureHierarchy() {
        
        view.addSubview(homeCollectionView)
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
    }
    
    override func configureLayout() {
        
        homeCollectionView.snp.makeConstraints { make in
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
    
    private func configureMenu() -> UIMenu {
        
        let sortedByTitle = UIAction(title: "제목 순으로 보기") { _ in
        }
        
        let sortedByDate = UIAction(title: "마감일 순으로 보기") { _ in
        }
        
        let sortedByPriority = UIAction(title: "우선순위 순으로 보기") { _ in
        }
        
        let items = [
            sortedByTitle,
            sortedByDate,
            sortedByPriority
        ]
        
        return UIMenu(children: items)
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
    
    @objc private func updateCollectionView() {
        
        homeCollectionView.reloadData()
    }
    
    @objc private func pushListViewController() {
        
        navigationController?.pushViewController(ListViewController(data: HomeCollectionViewCellType.all.data,
                                                                    type: .all), animated: true)
    }
    
    @objc private func addTodo() {
        
        let nv = UINavigationController(rootViewController: EnrollViewController())
        nv.modalPresentationStyle = .fullScreen
        
        present(nv,
                animated: true)
    }
    
    @objc private func addList() {
        
        navigationController?.pushViewController(ListViewController(data: HomeCollectionViewCellType.all.data,
                                                                    type: .all), animated: true)
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
