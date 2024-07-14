//
//  FolderListViewController.swift
//  Reminder
//
//  Created by 최승범 on 7/13/24.
//

import UIKit
import SnapKit

final class FolderListViewController: BaseViewController {
    
    private let listTableView = UITableView()
    
    private let viewModel = FolderListViewModel()
    
    init(selectFolder: ((CustomTodoFolder?) -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        viewModel.selectFolder = selectFolder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .baseFont
    }
    
    override func configureHierarchy() {
        view.addSubview(listTableView)
    }
    
    override func configureUI() {
        
        view.backgroundColor = .modalBackground
        
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.rowHeight = 60
        listTableView.layer.cornerRadius = 8
        listTableView.register(CustomFolderTableViewCell.self,
                               forCellReuseIdentifier: CustomFolderTableViewCell.identifier)
        
    }
    
    override func configureLayout() {
        
        listTableView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
}

//MARK: - TableView Delegate, DataSource
extension FolderListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.folderList.count + 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomFolderTableViewCell.identifier,
                                                       for: indexPath) as? CustomFolderTableViewCell else {
            return CustomFolderTableViewCell()
        }
        
        if indexPath.row == 0 {
            
            cell.updateContent(data: nil)
        } else {
            
            let data = viewModel.folderList[indexPath.row - 1]
            cell.updateContent(data: data)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            viewModel.applyInput(.selectNil)
        } else {
            let data = viewModel.folderList[indexPath.row - 1]
            viewModel.applyInput(.selectFolder(data))
        }
        
        
        viewModel.selectFolder?(viewModel.selectedFolder)
        navigationController?.popViewController(animated: true)
    }
    
}

