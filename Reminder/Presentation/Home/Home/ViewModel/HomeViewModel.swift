//
//  HomeViewModel.swift
//  Reminder
//
//  Created by 최승범 on 7/10/24.
//

import Foundation
import Combine
import RealmSwift

final class HomeViewModel {
    
    enum InputType {
        case noValue
        case viewDidLoad
        case filteredFolderClicked(Int)
        case addNewTodo
        case addNewCustomFolder
        case customFolderClicked(Int)
        case deleteCustomFolder(Int)
        case searchTodo(String?)
        case filteredDate(Date)
    }
    
    @Published private(set) var searhResultList: [Todo]? = nil
    @Published private(set) var customFolderList = [CustomTodoFolder]()
    @Published private var input: InputType = .noValue
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        bindInput()
    }
    
    func applyUserInput(_ input: InputType) {
        self.input = input
    }
    
    private func bindInput() {
        
        $input.sink { [weak self] inputType in
            guard let self = self else { return }
            
            switch inputType {
            case .noValue:
                return
                
            case .viewDidLoad:
                readCustomFolder()
                
            case .filteredFolderClicked(let int):
                return
                
            case .addNewTodo:
                return
                
            case .addNewCustomFolder:
                readCustomFolder()
                
            case .customFolderClicked(let index):
                return
                
            case .deleteCustomFolder(let index):
                deleteFolder(index: index)
                
            case .searchTodo(let keyword):
                searchTodo(keyword: keyword)
                
            case .filteredDate(let date):
                filterDate(date: date)
                
            }
        }.store(in: &cancellable)
        
    }
    
}

extension HomeViewModel {
    
    private func readCustomFolder() {
        customFolderList = Array(DataBaseManager.shared.read(CustomTodoFolder.self))
    }
    
    private func filterDate(date: Date) {
        
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: date)!
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: date)!
        
        let searchedData = DataBaseManager.shared.read(Todo.self).where {
            $0.deadLine >= yesterday && $0.deadLine <= tomorrow
        }
        
        searhResultList = Array(searchedData)
    }
    
    private func deleteFolder(index: Int) {
        let folder = customFolderList[index]
        customFolderList.remove(at: index)
        DataBaseManager.shared.delete(folder)
    }
    
    private func searchTodo(keyword: String?) {
        
        guard let keyword = keyword else {
            searhResultList = nil
            return
        }
        
        if keyword.isEmpty {
            searhResultList = nil
        } else {
            let searhResult = DataBaseManager.shared.read(Todo.self).where {
                $0.title.contains(keyword,
                                  options: .caseInsensitive)
                || $0.subTitle.contains(keyword,
                                        options: .caseInsensitive)
            }
            
            searhResultList = Array(searhResult)
        }
    }
    
}
