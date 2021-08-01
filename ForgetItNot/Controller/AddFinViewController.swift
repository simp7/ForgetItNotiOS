//
//  AddFinViewController.swift
//  ForgetItNot
//
//  Created by 박정현 on 03/08/2019.
//  Copyright © 2019 박정현. All rights reserved.
//

import UIKit

class AddFinViewController: UIViewController {

    //MARK: - UI 오브젝트
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var rangeTextField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var optionList: UIStackView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var chooseSegment: UISegmentedControl!
    
    //MARK: - 변수
    
    var delegate: FinDelegate?
    var categories: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionList.spacing = 30.0
        
        categoryTextField.layer.borderWidth = 1.0
        rangeTextField.layer.borderWidth = 1.0
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        for i in textFields {
            i.delegate = self
        }
        
        Settings.settings.delegate = self
        Settings.setUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let categoryArray = categories {
            categoryPicker.selectRow(categoryArray.count, inComponent: 0, animated: false)
        }
        
    }
    
    //MARK: - ToolBar 관련 함수
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if let data = processData() {
            add(category: data.category)
            delegate?.insert(data)
            
            guard let categoryArray = categories else {fatalError()}
            delegate?.getCategories(categoryArray)
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - 저장 관련 함수
    
    func processData() -> FinData? {
        var data : FinData
        
        let emptyAlert = UIAlertController(title: NSLocalizedString("Oops!", comment: ""), message: NSLocalizedString("You should write category and range.", comment: ""), preferredStyle: .alert)
        let overlapAlert = UIAlertController(title: NSLocalizedString("Oops!", comment: ""), message: NSLocalizedString("You already have been added same item.", comment: ""), preferredStyle: .alert)
        
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil)
        
        emptyAlert.addAction(action)
        overlapAlert.addAction(action)
        
        if alertIfEmpty(in: categoryTextField.text, alert: emptyAlert) || alertIfEmpty(in: rangeTextField.text, alert: emptyAlert){
            return nil
        }
        
        let category = categoryTextField.text!
        let range = rangeTextField.text!
        
        if chooseSegment.selectedSegmentIndex == 0 {
            data = FinData(category: category, range: range, date: Settings.today)
        } else {
            data = FinData(category: category, range: range)
        }
        
        guard let isExist = delegate?.isAlreadyExist(data) else {fatalError()}
        if isExist {
            present(overlapAlert, animated: true)
            return nil
        }
        
        return data
        
    }
    
    func alertIfEmpty(in optionalText: String?, alert: UIAlertController) -> Bool {
        let text = optionalText ?? ""
        if text.isEmpty {
            present(alert, animated: true)
            return true
        }
        return false
    }
    
    @IBAction func categoryPutted(_ sender: UITextField) {
        
        guard let text = sender.text else {fatalError()}
        var categoryRow: Int?
        
        if let categoryArray = categories {
            
            var i = 0
            while i < categoryArray.count {
                if categoryArray[i] == text {
                    categoryRow = i
                }
                i += 1
            }
            
            if let index = categoryRow {
                categoryPicker.selectRow(index, inComponent: 0, animated: false)
            } else {
                categoryPicker.selectRow(categoryArray.count, inComponent: 0, animated: false)
            }
            
        }
        
    }
    
    func add(category: String) {
        if !isExist(category: category) {
            categories!.append(category)
            categories!.sort()
        }
    }
    
    func isExist(category: String) -> Bool {
        if let categoryArray = categories {
            for i in categoryArray {
                if i == category {
                    return true
                }
            }
        }
        return false
    }
    
}

//MARK: - UIPickerViewDelegate 관련 함수

extension AddFinViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let categoryArray = categories {
            return categoryArray.count + 1
        }
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let categoryArray = categories {
            categoryTextField.text = categoryArray.count == row ? "" : categoryArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var string = NSLocalizedString("New category", comment: "")
        
        if let categoryArray = categories {
            if categoryArray.count != row {
                string = categoryArray[row]
            }
        }
        
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: Settings.tint()])
        
    }
    
}

//MARK:- UITextFieldDelegate 관련 함수

extension AddFinViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    } //TextField 밖 터치 시 닫기
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return false
        }
        return true
    } // 복사 및 붙여넣기 방지
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {return true}
        let newLength = text.count + string.count - range.length
        
        return newLength <= 20
        
    }
    
}

//MARK: - SettingDelegate 관련 함수

extension AddFinViewController: SettingDelegate {
    
    func adjustColor() {
        
        let background = Settings.background()
        let tint = Settings.tint()
        
        view.backgroundColor = background
        
        for i in textFields {
            
            i.layer.borderWidth = 0
            let border = CALayer()
            let width = CGFloat(1.5)
            border.borderColor = tint.cgColor
            border.frame = CGRect(x: 0, y: i.frame.size.height - width, width: i.frame.size.width, height: i.frame.size.height)
            
            border.borderWidth = width
            i.layer.addSublayer(border)
            i.layer.masksToBounds = true
            
            i.backgroundColor = background
            i.textColor = tint
            i.tintColor = tint
            
        }
        
        categoryPicker.tintColor = tint
        
        toolbar.barTintColor = tint
        toolbar.tintColor = background
        
        categoryTextField.attributedPlaceholder = NSMutableAttributedString(string: NSLocalizedString("Category(within 20 letters)", comment: ""), attributes: [NSAttributedString.Key.foregroundColor:tint])
        rangeTextField.attributedPlaceholder = NSMutableAttributedString(string: NSLocalizedString("Range(within 20 letters)", comment: ""), attributes: [NSAttributedString.Key.foregroundColor:tint])
        
        chooseSegment.tintColor = background
        chooseSegment.backgroundColor = tint
        
        chooseSegment.setTitleTextAttributes([.foregroundColor: background], for: .normal)
        
        if #available(iOS 13.0, *) {
            chooseSegment.selectedSegmentTintColor = background
            chooseSegment.setTitleTextAttributes([.foregroundColor: tint], for: .selected)
        }
        
    }
    
}
