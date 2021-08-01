//
//  DeteManager.swift
//  ForgetItNot
//
//  Created by 박정현 on 2019/11/16.
//  Copyright © 2019 박정현. All rights reserved.
//

import Foundation

class DateManager {
    
    private var today = Settings.today
    private let formatter = DateFormatter()
    private let defaults = Settings.defaults
    private let deltaArray = [0, 1, 3, 7, 14, 28]
    
    init() {
        formatter.dateFormat = "yyyy-MM-dd"
    }
    
    func getFormatter() -> DateFormatter {
           
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
           
        return formatter
           
    }
       
    func encode(of date: Date) -> String {
           return getFormatter().string(from: date)
    }
    
    func updateLastDate() {
        defaults.lastDate = (encode(of: Settings.today))
    }
       
    func loadLastDate() -> String? {
        return defaults.lastDate
    }
       
    func isDatePassed() -> Bool {
        return encode(of: Settings.today) != loadLastDate()
    }
       
    func getExpiredDate() -> Date {
        return AddDay(to: -(deltaArray.last ?? 0) - 1)
    }
       
    func getGeneratedDate(of data: FinData) -> Date? {
        if let repetition = data.repetition.value {
            return AddDay(to: -deltaArray[repetition])
        }
        return nil
    }
    
    func getReviewDate() -> [Date] {
        var result = [Date](repeating: today, count: deltaArray.count)
        var i = 0
        for v in deltaArray {
            result[i] = AddDay(to: -v)
            i += 1
        }
        return result
    }
    
    func AddDay(to delta: Int) -> Date {
        guard let result = Calendar.current.date(byAdding: .day, value: delta, to: today) else {fatalError()}
        return result
    }
    
}
