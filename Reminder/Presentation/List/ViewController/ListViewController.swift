//
//  ListViewController.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

final class ListViewController: BaseViewController {
    
    private let listTableView = UITableView()
    private var data: Results<Todo> {
        didSet {
            listTableView.reloadData()
        }
    }
    
    init(data: Results<Todo>,
         type: HomeCollectionViewCellType) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
        
        configureTableHeaderView(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        let moreItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                       menu: configureMenu())
        
        navigationItem.rightBarButtonItem = moreItem
        
        let popItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(pVC))
        
        navigationItem.leftBarButtonItem = popItem
    }
    
    override func configureHierarchy() {
        view.addSubview(listTableView)
    }
    
    override func configureUI() {
        
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(ListTableViewCell.self,
                               forCellReuseIdentifier: ListTableViewCell.identifier)
        
    }
    
    override func configureLayout() {
        
        listTableView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    @objc private func pVC() {
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: .updateNotification, object: nil)
    }
    
}

//MARK: - ListVC private, @objc
extension ListViewController {
    
    private func configureMenu() -> UIMenu {
        
        let sortedByTitle = UIAction(title: "제목 순으로 보기") { [weak self] _ in
            guard let self = self else { return }
            data = data.sorted(byKeyPath: "title", ascending: true)
        }
        
        let sortedByDate = UIAction(title: "마감일 순으로 보기") { [weak self] _ in
            guard let self = self else { return }
            data = data.sorted(byKeyPath: "deadLine", ascending: true)
        }
        
        let sortedByPriority = UIAction(title: "우선순위 순으로 보기") { [weak self] _ in
            guard let self = self else { return }
            data = data.sorted(byKeyPath: "priority", ascending: true)
        }
        
        let items = [
            sortedByTitle,
            sortedByDate,
            sortedByPriority
        ]
        
        return UIMenu(children: items)
    }
    
    private func configureTableHeaderView(type: HomeCollectionViewCellType) {
        
        let headerView = TitleHeaderView(type: type)
        headerView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: listTableView.frame.width,
                                  height: 44)
        listTableView.tableHeaderView = headerView
    }
    
}

//MARK: - TableView Delegate, DataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier,
                                                       for: indexPath) as? ListTableViewCell else {
            return ListTableViewCell()
        }
        let data = data[indexPath.row]
        cell.changeState = {
            DataBaseManager.shared.update(data) { data in
                data.isDone.toggle()
            }
            
            return data.isDone
        }
        cell.updateContent(data: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal,
                                        title: nil) { [weak self] action, view, completionHandler in
            guard let self = self else { return }
            
            let todo = data[indexPath.row]
            DataBaseManager.shared.delete(todo)
            tableView.reloadData()
        }
        
        let favorite = UIContextualAction(style: .normal,
                                          title: nil) { [weak self] action, view, completionHandler in
            guard let self = self else { return }
            
            
            let data = data[indexPath.row]
            
            DataBaseManager.shared.update(data) { data in
                data.isPined.toggle()
            }
            
        }
        
        delete.backgroundColor = #colorLiteral(red: 0.9982114434, green: 0.3084382713, blue: 0.2676828206, alpha: 1)
        delete.image = UIImage(systemName: "trash")
        
        favorite.backgroundColor = #colorLiteral(red: 1, green: 0.6641262174, blue: 0.07634276897, alpha: 1)
        favorite.image = UIImage(systemName: "flag.circle.fill")
        
        let configuration = UISwipeActionsConfiguration(actions: [delete, favorite])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
}

