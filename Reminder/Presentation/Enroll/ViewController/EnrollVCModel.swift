//
//  EnrollVCModel.swift
//  Reminder
//
//  Created by 최승범 on 7/4/24.
//

import UIKit
import RealmSwift

final class EnrollVCModel {
    
    enum EnrollType {
        case create
        case edit
    }
    
    private let photoManager = PhotoManager()
    var todo = Todo(title: "")
    var type: EnrollType = .create
    var editId: ObjectId?
    @Published var photoImage: UIImage?
    
    func saveTodo() {
        
        if let editId = editId {
            todo.id = editId
        }
        
        if todo.priority == nil {
            todo.priority = PriorityType.no.rawValue
        }
        
        savePhoto()
    
        DataBaseManager.shared.add(todo)
    }
    
    func changeTagsToList(value: [String]) {
        
        let list = List<String>()
        value.forEach { tag in
            list.append(tag)
        }
        todo.tag = list
    }
    
    func changeListToTags() -> [String] {
        return Array(todo.tag)
    }
    
    private func savePhoto() {
        
        if let photoImage = photoImage {
            todo.imageName = "\(todo.id)"
            photoManager.saveImageToDocument(image: photoImage,
                                             filename: "\(todo.id)")
        }
    }
    
}

