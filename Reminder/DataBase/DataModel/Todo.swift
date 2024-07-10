//
//  Todo.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import Foundation
import RealmSwift

final class Todo: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var subTitle: String?
    @Persisted var deadLine: Date?
    @Persisted var tag: List<String> = List<String>()
    @Persisted var priority: Int?
    @Persisted var imageName: String?
    @Persisted var releaseDate: Date = Date()
    @Persisted var isPined = false
    @Persisted var isDone = false
    
    @Persisted(originProperty: "todoList") var folder: LinkingObjects<CustomTodoFolder>
    
    convenience init(title: String,
                     priority: Int? = nil,
                     subTitle: String? = nil,
                     deadLine: Date? = nil,
                     imageName: String? = nil) {
        self.init()
    
        self.title = title
        self.subTitle = subTitle
        self.deadLine = deadLine
        self.priority = priority
        self.imageName = imageName
    }
}
