//
//  EnrollVCModel.swift
//  Reminder
//
//  Created by 최승범 on 7/4/24.
//

import UIKit
import RealmSwift

final class EnrollVCModel {
    
    private let photoManager = PhotoManager()
    var todo = Todo(title: "")
    @Published var photoImage: UIImage?
    
    func saveTodo() {
        
        if let photoImage = photoImage {
            todo.imageName = "\(todo.id)"
            photoManager.saveImageToDocument(image: photoImage,
                                             filename: "\(todo.id)")
        }
        
        if todo.priority == nil {
            todo.priority = PriorityType.no.rawValue
        }
        
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
    
}
