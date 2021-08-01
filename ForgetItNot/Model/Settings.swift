//
//  Settings.swift
//  ForgetItNot
//
//  Created by 박정현 on 07/08/2019.
//  Copyright © 2019 박정현. All rights reserved.
//

import Foundation
import UIKit
import DynamicColor

class Settings {
    
    static let settings = Settings()
    static let defaults = Defaults()
    
    static var today = Date()
    static var auth = false
    
    var themes = [ThemeData]()
    
    private var currentTheme: ThemeData {
        didSet {
            Settings.setUI()
        }
    }
    
    private var isNotify: Bool {
        set(state) {
            Settings.defaults.isNotify = state
        }
        get {
            return Settings.defaults.isNotify
        }
    }
    
    var delegate: SettingDelegate?
    
    private init() {
        themes = ThemeData.GetStandardTheme()
        currentTheme = themes[Settings.defaults.theme]
    }
    
    func getTheme(){
        currentTheme = themes[Settings.defaults.theme]
    }
    
    func changeTheme(to row: Int){
        currentTheme = themes[row]
        Settings.defaults.theme = row
    }
    
    
    //MARK: - 변수 접근을 위한 Static 함수
    
    static func setUI(){
        settings.delegate?.adjustColor()
    }
    
    static func cellColors() -> [UIColor]{
        return settings.currentTheme.colors
    }
    
    static func background() -> UIColor {
        return settings.currentTheme.background
    }
    
    static func tint() -> UIColor {
        return adjustTint(Settings.background())
    }
    
    static func adjustTint(_ bg: UIColor) -> UIColor {
        return bg.isLight() ? UIColor.black : UIColor.white
    }
    
    static func themeList() -> [String] {
        
        var themeList = [String]()
        
        for i in settings.themes {
            themeList.append(i.name)
        }
        
        return themeList
        
    }
    
    static func setNotification(_ state: Bool){
        Settings.settings.isNotify = state
    }
    
    static func getNotification() -> Bool {
        let isOn = Settings.settings.isNotify
        return isOn
    }
    
    static func isPurchased() -> Bool {
        return Settings.defaults.isPurchased
    }
    
    static func purchase() {
        Settings.defaults.isPurchased = true
    }
    
}

protocol SettingDelegate {
    func adjustColor()
}

