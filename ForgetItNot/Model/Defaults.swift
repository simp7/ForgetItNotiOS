//
//  Defaults.swift
//  ForgetItNot
//
//  Created by 박정현 on 2019/11/16.
//  Copyright © 2019 박정현. All rights reserved.
//

import Foundation

class Defaults {
    
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    public var categories : [String] {
        set(newNames) {
            defaults.set(newNames, forKey: "categories")
        }
        get {
            return defaults.stringArray(forKey: "categories") ?? []
        }
    }
    
    public var theme : Int {
        set(newTheme) {
            defaults.set(newTheme, forKey: "theme")
        }
        get {
            return defaults.integer(forKey: "theme")
        }
    }
    
    public var isNotify : Bool {
        set(state) {
            defaults.set(state, forKey: "notify")
        }
        get {
            return defaults.bool(forKey: "notify")
        }
    }
    
    public var notifyIdentifier : String? {
        set(id) {
            defaults.set(id, forKey: "notifyIdentifier")
        }
        get {
            return defaults.string(forKey: "notifyIdentifier")
        }
    }
    
    public var isPurchased : Bool {
        set(state) {
            defaults.set(state, forKey: "io.github.simp7.ForgetItNot.RemoveAds")
        }
        get {
            return defaults.bool(forKey: "io.github.simp7.ForgetItNot.RemoveAds")
        }
    }
    
    public var lastDate : String? {
        set(state) {
            defaults.set(state, forKey: "lastDate")
        }
        get {
            return defaults.string(forKey: "lastDate")
        }
    }
    
}
