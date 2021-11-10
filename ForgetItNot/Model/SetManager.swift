//
//  SetManager.swift
//  ForgetItNot
//
//  Created by 박정현 on 2020/09/04.
//  Copyright © 2020 박정현. All rights reserved.
//

import Foundation
import RealmSwift

class SetManager {
    
    private let realm = try! Realm()
    private var today = FinSet(date: Settings.today)
    private let assignment = FinSet()
    private let date = DateManager()
    
    init(datePassed: Bool) {
        today = realm.object(ofType: FinSet.self, forPrimaryKey: date.encode(of: Settings.today)) ?? realm.create(FinSet.self, value: today, update: .all)
        if datePassed {
            deleteExpired()
        }
    }
    
    func get(from genDate: Date? = nil) -> FinSet? {
        var result = "assignments"
        if let d = genDate {
            result = date.encode(of: d)
        }
        return realm.object(ofType: FinSet.self, forPrimaryKey: result)
    }
    
    func delete(_ fin: FinData) {
        var target : FinSet
        if let generated = date.getGeneratedDate(of: fin) {
            target = realm.object(ofType: FinSet.self, forPrimaryKey: date.encode(of: generated))!
        } else {
            target = realm.object(ofType: FinSet.self, forPrimaryKey: "assignments")!
        }
        target.delete(fin)
    }
    
    func deleteExpired() {
        let expiredData = realm.objects(FinSet.self).filter({(arr) in
            guard let selected = arr.date else {return false}
            return selected < self.date.getExpiredDate()
        })
        realm.delete(expiredData)
    }
    
    func insert(_ fin: FinData) {
        
        if fin.repetition.value != nil {
            today.insert(fin)
            return
        }
        
        if realm.object(ofType: FinSet.self, forPrimaryKey: "assignments") == nil {
            realm.add(assignment, update: .all)
        }
        
        realm.object(ofType: FinSet.self, forPrimaryKey: "assignments")!.insert(fin)
        
    }
    
}
