//
//  Findata.swift
//  ForgetItNot
//
//  Created by 박정현 on 30/07/2019.
//  Copyright © 2019 박정현. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class FinData: Object {
    
    dynamic var category: String = ""
    dynamic var range: String = ""
    dynamic var date: String?
    dynamic var repetition = RealmProperty<Int?>()
    dynamic var key: String = ""
    
    let included = LinkingObjects(fromType: FinSet.self, property: "data")
    let calledToReview = LinkingObjects(fromType: Todo.self, property: "data")
    
    init(category: String, range: String, date: Date? = nil) {
        self.category = category
        self.range = range
        if let d = date {
            self.date = DateManager().encode(of: d)
        }
        self.repetition.value = date == nil ? nil : 0
        self.key = FinData.getKey(category: category, range: range, date: self.date)
    }
    
    override class func primaryKey() -> String? {
        return "key"
    }
    
    required override init() {
    }
    
    static func == (a : FinData, b : FinData) -> Bool {
        return a.key == b.key
    }
    
    static func getKey(category: String, range: String, date: String?) -> String {
        return "\(category)|\(date ?? "assignment")|\(range)"
    }
        
}
