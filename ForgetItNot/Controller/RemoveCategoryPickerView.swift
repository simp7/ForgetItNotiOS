//
//  RemoveCategoryPickerView.swift
//  ForgetItNot
//
//  Created by 박정현 on 06/08/2019.
//  Copyright © 2019 박정현. All rights reserved.
//

import UIKit

class RemoveCategoryPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    var finDelegate: FinDelegate?
    var categories: [String]?
    var tint = UIColor.white
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if isCategoryExist() {
            return categories!.count
        } else {
            return 1
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var category = NSLocalizedString("There is no category.", comment: "")
        
        if isCategoryExist() {
            category = categories![row]
        }
        
        return NSAttributedString(string: category, attributes: [NSAttributedString.Key.foregroundColor: tint])
        
    }
    
    func isCategoryExist() -> Bool {
        if let categories = categories {
            if categories.count != 0 {
                return true
            }
        }
        return false
    }

}
