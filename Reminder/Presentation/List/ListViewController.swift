//
//  ListViewController.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit
import SnapKit

final class ListViewController: BaseViewController {
    
    private let listTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureNavigationBar() {
    
        let moreItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                menu: configureMenu())

        navigationItem.rightBarButtonItem = moreItem
    }
    
    override func configureHierarchy() {
        view.addSubview(listTableView)
    }
    
    override func configureUI() {
        
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(ListTableViewCell.self,
                               forCellReuseIdentifier: ListTableViewCell.identifier)
        let headerView = ListTableHeaderView(frame: CGRect(x: 0,
                                                           y: 0,
                                                           width: listTableView.frame.width,
                                                           height: 44))
        listTableView.tableHeaderView = headerView
    }
    
    override func configureLayout() {
        
        listTableView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

//MARK: - ListVC private, @objc
extension ListViewController {
    
    private func configureMenu() -> UIMenu {
        
        let sortedByTitle = UIAction(title: "제목 순으로 보기") { [weak self] _ in
        }
        
        let sortedByDate = UIAction(title: "마감일 순으로 보기") { [weak self] _ in
        }
        
        let sortedByimportant = UIAction(title: "우선순위 순으로 보기") { [weak self] _ in
        }
        
        let items = [
           sortedByTitle,
           sortedByDate,
           sortedByimportant
        ]
        
        return UIMenu(children: items)
    }
  
}

//MARK: - TableView Delegate, DataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return DataBaseManager.shared.read(Todo.self).count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier,
                                                       for: indexPath) as? ListTableViewCell else {
            return ListTableViewCell()
        }
        let data = DataBaseManager.shared.read(Todo.self)[indexPath.row]
        cell.updateContent(data: data)
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal,
                                        title: "삭제") { action, view, completionHandler in
            let todo = DataBaseManager.shared.read(Todo.self)[indexPath.row]
            DataBaseManager.shared.delete(todo)
            tableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}

