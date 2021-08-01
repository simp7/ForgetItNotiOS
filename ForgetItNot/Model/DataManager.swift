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
    private var todo : Todo {
        set(value) {
            do {
                try realm.write {
                    realm.delete(todo)
                    realm.add(value, update: .modified)
                }
            } catch {
                print("Failed to write todo")
            }
        }
        get {
            return realm.object(ofType: Todo.self, forPrimaryKey: "todo") ?? Todo()
        }
    }
    
    private var todaySet = FinSet()
    
    init() {
    }
    
    func sizeOfTodo() -> Int {
        return todo.size()
    }
    
    func cellContent(_ idx: Int) -> FinData? {
        return todo.get(idx)
    }
    
    func save(_ fin: FinData) {
        do {
            try realm.write {
                realm.add(fin)
            }
        } catch {
            print("Errors when write FinData")
        }
    }
    
    func get(setFrom date: Date? = nil) -> FinSet? {
        var result : String = "assignments"
        if let d = date {
            result = DateManager().encode(of: d)
        }
        return realm.object(ofType: FinSet.self, forPrimaryKey: result)
    }
    
    func delete(fin data: FinData) {
        do {
            try realm.write {
                deleteFromSet(fin: data)
                deleteFromTodo(fin: data)
            }
        } catch {
            print("Errors deleting finData")
        }
    }
    
    func dayPassed(limit: Date) {
        do {
            try realm.write {
                clearFinOfToday()
                deleteExpired(limit: limit)
            }
        } catch {
            print("Errors when dayPassed")
        }
    }
    
    func load() {
        
    }
    
    func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Errors when deleting all")
        }
    }
    
    private func deleteFromSet(fin: FinData) {
        let date = DateManager()
        var target : FinSet
        if let generated = date.getGeneratedDate(of: fin) {
            target = realm.object(ofType: FinSet.self, forPrimaryKey: date.encode(of: generated))!
        } else {
            target = realm.object(ofType: FinSet.self, forPrimaryKey: "assignments")!
        }
        target.delete(fin)
    }
    
    private func deleteFromTodo(fin: FinData) {
        todo.remove(fin)
    }
    
    private func clearFinOfToday() {
        realm.delete(todo)
    }
    
    private func deleteExpired(limit: Date) {
        let expired = try realm.objects(FinSet.self).filter({(arr) in
            guard let selected = arr.date else {return false}
            return selected < limit
        })
        realm.delete(expired)
    }
    
}
