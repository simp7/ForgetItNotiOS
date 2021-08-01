//
//  ChangeColorPickerView.swift
//  ForgetItNot
//
//  Created by 박정현 on 06/08/2019.
//  Copyright © 2019 박정현. All rights reserved.
//

import UIKit

class ChangeColorPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var themeList = [String]()
    var tint = UIColor.white
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return themeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Settings.settings.changeTheme(to: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: themeList[row], attributes: [NSAttributedString.Key.foregroundColor: tint])
    }
    
}
