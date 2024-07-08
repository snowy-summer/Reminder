//
//  ExtraTodoInFolderViewController.swift
//  Reminder
//
//  Created by 최승범 on 7/8/24.
//

import UIKit
import SnapKit
import RealmSwift

final class ExtraTodoInFolderViewController: BaseViewController {
    
    private let listTableView = UITableView()
    private var model: List<Todo> {
        didSet {
            listTableView.reloadData()
        }
    }
    
    init(data: Folder) {
        self.model = data.todoList
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listTableView.reloadData()
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        let moreItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"))
        
        navigationItem.rightBarButtonItem = moreItem
        
        let popItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(popVC))
        
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
    
}

//MARK: - private, @objc
extension ExtraTodoInFolderViewController {
    
    @objc private func popVC() {
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: .updateHomeNotification, object: nil)
    }
    
    @objc private func updateTable() {
        
        listTableView.reloadData()
    }
    
}

//MARK: - TableView Delegate, DataSource
extension ExtraTodoInFolderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier,
                                                       for: indexPath) as? ListTableViewCell else {
            return ListTableViewCell()
        }
        let data = model[indexPath.row]
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
            
            let todo = model[indexPath.row]
            DataBaseManager.shared.delete(todo)
            tableView.reloadData()
        }
        
        let favorite = UIContextualAction(style: .normal,
                                          title: nil) { [weak self] action, view, completionHandler in
            guard let self = self else { return }
            
            
            let data = model[indexPath.row]
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = model[indexPath.row]
        navigationController?.pushViewController(EnrollViewController(todo: data, type: .edit), animated: true)
    }
    
}

