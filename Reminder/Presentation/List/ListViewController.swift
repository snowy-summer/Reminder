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
                                       style: .plain,
                                       target: self,
                                       action: #selector(moreButtonClicked))
        
        navigationItem.rightBarButtonItem = moreItem
    }
    
    override func configureUI() {
        
        listTableView.delegate = self
        listTableView.dataSource = self
    }
    
}

//MARK: - ListVC private, @objc
extension ListViewController {
    
    @objc private func moreButtonClicked() {
        
    }

}

//MARK: - TableView Delegate, DataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier,
                                                       for: indexPath) as? ListTableViewCell else {
            return ListTableViewCell()
        }
        
        return cell
    }
    
}

