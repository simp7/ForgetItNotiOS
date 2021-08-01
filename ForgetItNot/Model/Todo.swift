//
//  Todo.swift
//  ForgetItNot
//
//  Created by 박정현 on 2019/11/15.
//  Copyright © 2019 박정현. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Todo : Object{
    
    let data = List<FinData>()
    
    required override init() {
        
    }
    
    func add(array: FinSet) {
        for i in array.data {
            data.append(i)  // 배열을 삽입할 때에는 최근 것부터 추가해 위에 있도록 해야 한다.
        }
    }
    
    func add(fin: FinData) {
        data.insert(fin, at: 0) // 원소를 삽입할 때에는 맨 위에 위치하도록 해야 한다.
    }
    
    func remove(_ f: FinData) {
        var i = 0, s = size()
        while (i < s) {
            if (data[i] == f) {
                data.remove(at: i)
                return
            }
            i += 1
        }
    }
    
    func size() -> Int {
        return data.count
    }
    
    func get(_ idx: Int) -> FinData? {
        if idx < size() {
            return data[idx]
        }
        return nil
    }
    
}
