//
//  CustomTodoFolder.swift
//  Reminder
//
//  Created by 최승범 on 7/8/24.
//

import Foundation
import RealmSwift

final class CustomTodoFolder: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var iconName: String
    
    @Persisted var todoList: List<Todo>
    
    convenience init(name: String,
                     iconName: String) {
        self.init()
        
        self.name = name
        self.iconName = iconName
    }
}
