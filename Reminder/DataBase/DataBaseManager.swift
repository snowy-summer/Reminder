//
//  DataBaseManager.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import Foundation
import RealmSwift

final class DataBaseManager {
    
    static let shared = DataBaseManager()
    private(set) var realm: Realm
    
    private init() {
        self.realm = try! Realm()
    }
    
    func add<T: Object>(_ object: T) {
                
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print(error)
        }
    }
    
    func read<T: Object>(_ object: T.Type) -> Results<T> {
        return realm.objects(object)
    }
    
    func update<T: Object>(_ object: T,
                           completion: @escaping ((T) -> ())) {
        
            do {
                try realm.write {
                    completion(object)
                }

            } catch let error {
                print(error)
            }
        }
    
    func delete<T: Object>(_ object: T) {
        
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print(error)
        }
    }
    
}
