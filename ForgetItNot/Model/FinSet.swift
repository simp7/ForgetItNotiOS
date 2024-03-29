//
//  FinArray.swift
//  ForgetItNot
//
//  Created by 박정현 on 2019/11/17.
//  Copyright © 2019 박정현. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class FinSet : Object {
    
    dynamic var dateString : String
    dynamic var date : Date?
    dynamic var data = List<FinData>()
    
    init(date : Date) {
        dateString = DateManager().encode(of: date)
        self.date = date
    }
    
    required override init() {
        dateString = "assignments"
        date = nil
    }
    
    override static func primaryKey() -> String? {
        return "dateString"
    }
    
    func insert(_ target: FinData) {
        data.append(target)
    }
    
    func delete(_ target: FinData) {
        for (index, selected) in data.enumerated() {
            if selected == target {
                data.remove(at: index)
                return
            }
        }
    }
    
    func isThere(_ target: FinData) -> Bool {
        return data.filter{$0 == target}.count > 0
    }
    
    func updateRepetition(by repetition: Int) {
        for fin in data {
            fin.repetition.value = repetition
        }
    }
    
}
