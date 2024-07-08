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
    
    private init() { }
    
    func getFileURL() {
        let realm = try! Realm()
        print(realm.configuration.fileURL)
    }
    
    func add<T: Object>(_ object: T) {
                
        do {
           let realm = try Realm()
           
           try realm.write {
               realm.add(object, update: .modified)
           }
        } catch let error {
           print(error)
        }
    }
    
    func read<T: Object>(_ object: T.Type) -> Results<T> {
        
        let realm = try! Realm()
        
        return realm.objects(object)
    }
    
    func update<T: Object>(_ object: T,
                           completion: @escaping ((T) -> ())) {
        
            do {
                let realm = try Realm()
                try realm.write {
                    completion(object)
                }

            } catch let error {
                print(error)
            }
        }
    
    func delete<T: Object>(_ object: T) {
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print(error)
        }
    }
    
}
