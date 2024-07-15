//
//  ListViewController.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit
import Combine
import SnapKit
import RealmSwift

final class ListViewController: BaseViewController {
    
    private let listTableView = UITableView()
    private let viewModel: ListViewModel
    private var cancellable = Set<AnyCancellable>()
    
    init(data: [Todo],
         name: String,
         color: UIColor) {
        self.viewModel = ListViewModel(todoList: data)
        super.init(nibName: nil, bundle: nil)
        configureTableHeaderView(name: name,
                                 color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingOutput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listTableView.reloadData()
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        let moreItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                       menu: configureMenu())
        
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

//MARK: - ListVC private, @objc
extension ListViewController {
    
    private func bindingOutput() {
        
        viewModel.$reloadOutPut.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.listTableView.reloadData()
            }.store(in: &cancellable)
    }
    
    private func configureMenu() -> UIMenu {
        
        let sortedByTitle = UIAction(title: "제목 순으로 보기") { [weak self] _ in
            guard let self = self else { return }
            viewModel.applyInput(.sortedByTitle)
        }
        
        let sortedByDate = UIAction(title: "마감일 순으로 보기") { [weak self] _ in
            guard let self = self else { return }
            viewModel.applyInput(.sortedByDate)
        }
        
        let sortedByPriority = UIAction(title: "우선순위 순으로 보기") { [weak self] _ in
            guard let self = self else { return }
            viewModel.applyInput(.sortedByPriority)
        }
        
        let items = [
            sortedByTitle,
            sortedByDate,
            sortedByPriority
        ]
        
        return UIMenu(children: items)
    }
    
    private func configureTableHeaderView(name: String,
                                          color: UIColor) {
        
        let headerView = TitleHeaderView(name: name,
                                         color: color)
        headerView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: listTableView.frame.width,
                                  height: 44)
        listTableView.tableHeaderView = headerView
    }
    
    @objc private func popVC() {
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: .updateHomeNotification, object: nil)
    }
}

//MARK: - TableView Delegate, DataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.todoList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier,
                                                       for: indexPath) as? ListTableViewCell else {
            return ListTableViewCell()
        }
        
        let data = viewModel.todoList[indexPath.row]
        
        cell.changeState = { [weak self] in
           
            self?.viewModel.applyInput(.doneToggle(indexPath.row))
            return data.isDone
        }
        cell.updateContent(data: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal,
                                        title: nil) { [weak self] action, view, completionHandler in
            guard let self = self else { return }
            
            viewModel.applyInput(.removeTodo(indexPath.row))
            return
        }
        
        let favorite = UIContextualAction(style: .normal,
                                          title: nil) { [weak self] action, view, completionHandler in
            guard let self = self else { return }
            
            viewModel.applyInput(.favoriteToggle(indexPath.row))
            return
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
        
        let data = viewModel.todoList[indexPath.row]
        navigationController?.pushViewController(EnrollViewController(todo: data) { [weak self] in
            self?.listTableView.reloadRows(at: [indexPath],
                                           with: .none)
        },
                                                 animated: true)
    }
    
}

