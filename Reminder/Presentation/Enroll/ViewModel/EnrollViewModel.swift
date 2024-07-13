//
//  EnrollViewModel.swift
//  Reminder
//
//  Created by 최승범 on 7/11/24.
//

import Foundation
import Combine

final class EnrollViewModel {
    
    enum InputType {
        case noValue
        
        case updateTitle(String?)
        case updateSubTitle(String?)
        
        case expandDateCell
        case selectDate(Date?)
        
        case selectPriority(Int?)
        
        case expandTagCell
        case updateTags([String])
        case addTag(String?)
        case removeTag(Int)
        
        case pinTogle
        
        case addImage(String)
        
        case saveTodo
    }
    
    @Published private var input: InputType = .noValue
    @Published private(set) var canSave = false
    
    private(set) var todo = Todo(title: "")
    private var folder: CustomTodoFolder?
    
    @Published private(set) var deadLine: Date?
    @Published private(set) var isDateExpand = false
    @Published private(set) var tagList = [String]()
    @Published private(set) var isTagExpand = false
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        bindingInput()
    }
    
    func applyInput(_ input: InputType) {
        self.input = input
    }
    
    private func bindingInput() {
        
        $input.sink { [weak self] inputType in
            guard let self = self else { return }
            
            switch inputType {
            case .noValue:
                return
        
            case .updateTitle(let title):
                updateTitle(text: title)
                
            case .updateSubTitle(let subTitle):
                updateSubTitle(text: subTitle)
//MARK: - 날짜
            case .expandDateCell:
                expandDateCell()
                
            case .selectDate(let date):
                updateDate(date: date)
//MARK: - 우선 순위
            case .selectPriority(let priority):
                updatePriority(value: priority)
//MARK: - 태그
            case .expandTagCell:
                expandTagCell()
                
            case .updateTags(let tags):
                updateTags(tags: tags)
                
            case .addTag(let tag):
                addTag(tag: tag)
                
            case .removeTag(let index):
                removeTag(index: index)
//MARK: - 깃발
            case .pinTogle:
                pinToggle()
//MARK: - 이미지
            case .addImage(let imageName):
                addImage(imageName: imageName)
                
            case .saveTodo:
                saveTodo()
          
            }
            
        }.store(in: &cancellable)
    }
}

//MARK: - Title, SubTitle
extension EnrollViewModel {
    
    private func updateTitle(text: String?) {
        guard let text = text else { return }
        
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            canSave = false
        } else {
            todo.title = text
            canSave = true
        }
        
    }
    
    private func updateSubTitle(text: String?) {
        guard let text = text else { return }
        
        todo.subTitle = text
    }
}

//MARK: - Date
extension EnrollViewModel {
    
    private func updateDate(date: Date?) {
        deadLine = date
    }
    
    private func expandDateCell() {
        isDateExpand.toggle()
    }
    
}

//MARK: - 태그
extension EnrollViewModel {
    
    private func expandTagCell() {
        isTagExpand.toggle()
    }
    
    private func updateTags(tags: [String]) {
        
        todo.tag.removeAll()
        
        tags.forEach { value in
            todo.tag.append(value)
        }
        tagList = tags
    }
    
    private func addTag(tag: String?) {
        
        guard let text = tag else { return }
        
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            tagList.contains(text) {
            return
        }
        let tagText = "#" + text
        tagList.append(tagText)
    }
    
    private func removeTag(index: Int) {
        tagList.remove(at: index)
    }
}

//MARK: - pin, image, priority
extension EnrollViewModel {
    
    private func updatePriority(value: Int?) {
        todo.priority = value
    }
    
    private func pinToggle() {
        todo.isPined.toggle()
    }
    
    private func addImage(imageName: String) {
        todo.imageName = imageName
    }
    
    private func saveTodo() {
        
        if isDateExpand {
            todo.deadLine = deadLine
        }
        
        if isTagExpand {
            tagList.forEach { value in
                todo.tag.append(value)
            }
        }
        
        if let folder = folder {
            DataBaseManager.shared.update(folder) { [weak self] folder in
                guard let self = self else { return }
                folder.todoList.append(todo)
            }
        } else {
            DataBaseManager.shared.add(todo)
        }
    }
}
