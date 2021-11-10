//
//  TodoManager.swift
//  ForgetItNot
//
//  Created by 박정현 on 2020/09/10.
//  Copyright © 2020 박정현. All rights reserved.
//

import Foundation
import RealmSwift

class TodoManager {
    
    private let realm = try! Realm()
    private let date = DateManager()
    private let todo : Todo
    
    init(datePassed: Bool) {
        
        let todoObj = realm.objects(Todo.self)
        
        if todoObj.count != 0 && !datePassed {
            todo = todoObj.first!
            return
        }
        
        realm.delete(todoObj)
        todo = realm.create(Todo.self)
        getFinOfToday()
        
    }
    
    func size() -> Int {
        return todo.size()
    }
    
    func get(from idx: Int) -> FinData? {
        return todo.get(idx)
    }
    
    func delete(_ fin: FinData) {
        todo.remove(fin)
    }
    
    func insert(_ fin: FinData) {
        todo.add(fin: fin)
    }
    
    func getFinOfToday() {
        
        if let assignment = realm.object(ofType: FinSet.self, forPrimaryKey: "assignments") {
            todo.add(array: assignment)
        }
        
        for (index, selected) in date.getReviewDate().enumerated() {
            
            debugPrint("get data from \(date.encode(of: selected))")
            if let target = realm.object(ofType: FinSet.self, forPrimaryKey: date.encode(of: selected)) {
                target.updateRepetition(by: index)
                todo.add(array: target)
            }
            
        }
        
    }
    
}
