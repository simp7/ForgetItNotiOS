//
//  ThemeData.swift
//  ForgetItNot
//
//  Created by 박정현 on 07/08/2019.
//  Copyright © 2019 박정현. All rights reserved.
//

import Foundation
import UIKit
import DynamicColor

class ThemeData {
    
    let name: String
    let colors: [UIColor]
    let background: UIColor
    
    init(themeName: String, colors: [UIColor], backgroundColor: UIColor) {
        
        name = themeName
        self.colors = colors
        background = backgroundColor
        
    }
    
    static func ForgetMeNot() -> ThemeData {
        return ThemeData(themeName: NSLocalizedString("Forget Me Not", comment: ""), colors: [UIColor.white, UIColor.blue.lighter(amount:0.45), UIColor(hexString: "#94baf8"), UIColor(hexString: "#4565dc"), UIColor(hexString: "#4055ae"), UIColor(hexString: "#192245")], backgroundColor: UIColor(hexString: "#4055ae"))
    }
    
    static func Rainbow() -> ThemeData {
        return ThemeData(themeName: NSLocalizedString("Rainbow", comment: ""), colors: [UIColor.red, UIColor.orange, UIColor.yellow.darkened(amount:0.05), UIColor.green.darkened(amount:0.2), UIColor.blue.lighter(amount: 0.1), UIColor.purple.lighter(amount: 0.1)], backgroundColor: UIColor.black)
    }
    
    static func BlackNWhite() -> ThemeData {
        return ThemeData(themeName: NSLocalizedString("Black & White", comment: ""), colors: [UIColor.white, UIColor.black, UIColor.white, UIColor.black, UIColor.white, UIColor.black], backgroundColor: UIColor.black)
    }
    
    static func Piano() -> ThemeData {
        return ThemeData(themeName: NSLocalizedString("Piano", comment: ""), colors: [UIColor.black, UIColor.white, UIColor.black, UIColor.white, UIColor.black, UIColor.white], backgroundColor: UIColor.white)
    }
    
    static func IntoTheSea() -> ThemeData {
        return ThemeData(themeName: NSLocalizedString("Into the sea", comment: ""), colors: [UIColor.white, UIColor.blue.lighter(amount: 0.3), UIColor.blue.lighter(), UIColor.blue.darkened(amount: 0.1), UIColor.blue.darkened(), UIColor.blue.darkened(amount: 0.5)], backgroundColor: UIColor.brown.lighter(amount: 0.375))
    }
    
    static func Silvertone() -> ThemeData {
        return ThemeData(themeName: NSLocalizedString("Silvertone", comment: ""), colors: [UIColor.white, UIColor.lightGray, UIColor.gray, UIColor.darkGray, UIColor.black.lighter(), UIColor.black], backgroundColor: UIColor.darkGray)
    }
    
    static func Ranked() -> ThemeData {
        return ThemeData(themeName: NSLocalizedString("Ranked", comment: ""), colors: [UIColor.brown.lighter(amount:0.1), UIColor.gray.lighter(), UIColor.orange.lighter(amount: 0.15), UIColor.blue.lighter().mixed(withColor: UIColor.green), UIColor.blue.lighter(amount: 0.25), UIColor.purple.mixed(withColor: UIColor.red)], backgroundColor: UIColor.gray.darkened(amount: 0.05))
    }
    
    static func GetStandardTheme() -> [ThemeData] {
        return [ThemeData.ForgetMeNot(), ThemeData.BlackNWhite(), ThemeData.Piano(), ThemeData.Rainbow(), ThemeData.IntoTheSea(), ThemeData.Silvertone()]
    }
    
    static func GetPremiumTheme() -> [ThemeData] {
        return [ThemeData.Ranked()]
    }
    
}
