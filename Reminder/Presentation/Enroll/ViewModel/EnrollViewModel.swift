//
//  EnrollViewModel.swift
//  Reminder
//
//  Created by 최승범 on 7/11/24.
//

import Foundation
import UIKit
import Combine

final class EnrollViewModel {
    
    enum InputType {
        case noValue
        
        case updateTitle(String?)
        case updateSubTitle(String?)
        
        case updateFolder(CustomTodoFolder?)
        
        case expandDateCell
        case selectDate(Date?)
        
        case selectPriority(Int)
        
        case expandTagCell
        case updateTags([String])
        case addTag(String?)
        case removeTag(Int)
        
        case pinTogle
        
        case appendImage(UIImage)
        case removeImage(Int)
        
        case saveTodo
    }
    
    @Published private var input: InputType = .noValue
    private let photoManager = PhotoManager()
    @Published private(set) var canSave = false
    
    private(set) var todo = Todo(title: "")
    @Published private(set) var folder: CustomTodoFolder?
    
    @Published private(set) var deadLine: Date?
    @Published private(set) var isDateExpand = false
    
    @Published private(set) var tagList = [String]()
    @Published private(set) var isTagExpand = false
    
    @Published private(set) var priority = 0
    @Published var imageList = [String]()
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
                
            case .updateFolder(let newFolder):
                folder = newFolder
//MARK: - 날짜
            case .expandDateCell:
                isDateExpand.toggle()
                
            case .selectDate(let date):
                deadLine = date
//MARK: - 우선 순위
            case .selectPriority(let value):
                priority = value
//MARK: - 태그
            case .expandTagCell:
                isTagExpand.toggle()
                
            case .updateTags(let tags):
                updateTags(tags: tags)
                
            case .addTag(let tag):
                addTag(tag: tag)
                
            case .removeTag(let index):
                tagList.remove(at: index)
//MARK: - 깃발
            case .pinTogle:
                todo.isPined.toggle()
//MARK: - 이미지
            case .appendImage(let image):
                appendImage(image: image)
        
            case .removeImage(let index):
                removeImage(index: index)
                
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

//MARK: - 태그
extension EnrollViewModel {
    
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
    
}

//MARK: - image, priority
extension EnrollViewModel {
    
    private func appendImage(image: UIImage) {
        
        let photoId = "\(UUID())"
        photoManager.saveImageToDocument(image: image, filename: photoId )
        imageList.append(photoId)
        
    }
    
    private func removeImage(index: Int) {
        
        photoManager.removeImageFromDocument(filename: imageList[index])
        imageList.remove(at: index)
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
        
        if !imageList.isEmpty {
            imageList.forEach { value in
                todo.imagesName.append(value)
            }
        }
        
        todo.priority = priority
        
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
