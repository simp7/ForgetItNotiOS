//
//  Realm Manager.swift
//  ForgetItNot
//
//  Created by 박정현 on 2020/09/02.
//  Copyright © 2020 박정현. All rights reserved.
//

import Foundation
import RealmSwift

class Database {
    
    private let realm = try! Realm()
    private var todo : TodoManager?
    private var finSet : SetManager?
    private static var instance : Database?
    
    private init() {
        let isPassed = DateManager().isDatePassed()
        debugPrint("url : \(Realm.Configuration.defaultConfiguration.fileURL!)")
        do {
            try realm.write {
                finSet = SetManager(datePassed: isPassed)
                todo = TodoManager(datePassed: isPassed)
            }
        } catch {
            fatalError("Error occured when initializing DB")
        }
    }
    
    static public func getInstance() -> Database {
        if instance == nil {
            instance = Database()
        }
        return instance!
    }
    
    func sizeOfTodo() -> Int {
        return todo?.size() ?? 0
    }
    
    func getTodo(from idx: Int) -> FinData? {
        return todo?.get(from: idx)
    }
    
    
    func delete(fin data: FinData) {
        do {
            try realm.write {
                realm.delete(realm.object(ofType: FinData.self, forPrimaryKey: data.key)!)
            }
        } catch {
            debugPrint("Error occured when deleting finData")
        }
    }
    
    func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            debugPrint("Error occured when deleting all data")
        }
        Database.instance = Database()
    }
    
    func clear(_ fin : FinData) {
        do {
            if fin.repetition.value == nil {
                delete(fin: fin)
            } else {
                try realm.write {
                    todo?.delete(fin)
                }
            }
        } catch {
            debugPrint("Error occured when clearing")
        }
    }
    
    func insert(_ fin: FinData) {
        do {
            try realm.write {
                realm.add(fin)
                todo?.insert(fin)
                finSet?.insert(fin)
            }
        } catch {
            debugPrint("Error occured when adding findata")
        }
    }
    
    func isThere(_ fin: FinData) -> Bool {
        return realm.object(ofType: FinData.self, forPrimaryKey: fin.key) != nil
    }
    
}
