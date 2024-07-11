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
    @Persisted var redColor: Double
    @Persisted var greenColor: Double
    @Persisted var blueColor: Double
    
    @Persisted var todoList: List<Todo>
    
    convenience init(name: String,
                     iconName: String,
                     red: Double,
                     green: Double,
                     blue: Double) {
        self.init()
        
        self.name = name
        self.iconName = iconName
        self.redColor = red
        self.greenColor = green
        self.blueColor = blue
    }
}
