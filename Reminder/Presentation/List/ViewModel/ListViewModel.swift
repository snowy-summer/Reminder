//
//  ListViewModel.swift
//  Reminder
//
//  Created by 최승범 on 7/14/24.
//

import Foundation
import Combine
import RealmSwift

final class ListViewModel {
    
    enum InputType {
        case noValue
        case removeTodo(Int)
        case favoriteToggle(Int)
        case doneToggle(Int)
        
        case sortedByTitle
        case sortedByDate
        case sortedByPriority
    }
    
    private(set) var todoList: [Todo]
    @Published private var input: InputType = .noValue
    @Published private(set) var reloadOutPut: Void?
    
    private var cancellable = Set<AnyCancellable>()
    
    init(todoList: [Todo]) {
        self.todoList = todoList
        bindingInput()
    }
    
    func applyInput(_ input: InputType) {
        self.input = input
    }
    
    private func bindingInput() {
        $input.sink { [weak self] newInput in
            guard let self = self else { return }
            
            switch newInput {
            case .noValue:
                return
                
            case .doneToggle(let index):
                let data = todoList[index]
                DataBaseManager.shared.update(data) { data in
                    data.isDone.toggle()
                }
                reloadOutPut = ()
                
            case .favoriteToggle(let index):
                let data = todoList[index]
                DataBaseManager.shared.update(data) { data in
                    data.isPined.toggle()
                }
                reloadOutPut = ()
                
            case .removeTodo(let index):
                let data = todoList[index]
                todoList.remove(at: index)
                DataBaseManager.shared.delete(data)
                reloadOutPut = ()
                
            case .sortedByTitle:
                todoList.sort {
                    $0.title < $1.title
                }
                
                reloadOutPut = ()
                
            case .sortedByDate:

                todoList.sort {

                    if let a = $0.deadLine, let b = $1.deadLine {
                           return a < b
                       } else if $0.deadLine != nil {
                
                           return true
                       } else if $1.deadLine != nil {
                           
                           return false
                       } else {
                           
                           return false
                       }
                }
                reloadOutPut = ()
                
            case .sortedByPriority:
                todoList.sort {

                    $0.priority < $1.priority
                }

                reloadOutPut = ()
            }
        }.store(in: &cancellable)
    }
}
