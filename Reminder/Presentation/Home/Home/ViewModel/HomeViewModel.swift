//
//  HomeViewModel.swift
//  Reminder
//
//  Created by 최승범 on 7/10/24.
//

import Foundation
import Combine
import RealmSwift

//protocol ViewModelAble {
////    enum InputType
//}

final class HomeViewModel {
    
    enum InputType {
        case none
        case viewDidLoad
        case filteredFolderClicked(Int)
        case addNewTodo
        case addNewCustomFolder
        case customFolderClicked(Int)
        case searchTodo(String?)
        case filteredDate(Date)
    }
    
    @Published private(set) var searhResultList: [Todo]? = nil
    @Published private(set) var customFolderList = [CustomTodoFolder]()
    @Published private var input: InputType = .none
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
            case .none:
                return
            case .viewDidLoad:
                customFolderList = Array(DataBaseManager.shared.read(CustomTodoFolder.self))
            case .filteredFolderClicked(let int):
                return
            case .addNewTodo:
                return
            case .addNewCustomFolder:
            return
            case .customFolderClicked(let int):
                return
            case .searchTodo(let keyword):
                
                guard let keyword = keyword else {
                    searhResultList = nil
                    return
                }
                
                if keyword.isEmpty {
                    searhResultList = nil
                } else {
                    print(keyword)
                   let searhResult = DataBaseManager.shared.read(Todo.self).where {
                        $0.title.contains(keyword,
                                          options: .caseInsensitive) 
                        || $0.subTitle.contains(keyword,
                                                options: .caseInsensitive)
                    }
                    
                    searhResultList = Array(searhResult)
                }
            case .filteredDate(let date):
                
                let calendar = Calendar.current
                let yesterday = calendar.date(byAdding: .day, value: -1, to: date)!
                let tomorrow = calendar.date(byAdding: .day, value: 1, to: date)!
                
                let searchedData = DataBaseManager.shared.read(Todo.self).where {
                    $0.deadLine >= yesterday && $0.deadLine <= tomorrow
                }
                
                searhResultList = Array(searchedData)
                
            }
        }.store(in: &cancellable)
        
    }
    
    
    
    
}
