//
//  FinInfoViewController.swift
//  ForgetItNot
//
//  Created by 박정현 on 05/08/2019.
//  Copyright © 2019 박정현. All rights reserved.
//

import UIKit
import SwipeCellKit

class FinInfoViewController: UIViewController {
    
    
    //MARK: - UI 오브젝트
    @IBOutlet weak var repetitionLabel: UILabel!
    @IBOutlet weak var finRangeLabel: UILabel!
    @IBOutlet weak var finRepetitionLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var buttonContainer: UIStackView!
    
    @IBOutlet var allText: [UILabel]!
    
    //MARK - 변수
    
    var delegate: FinDelegate?
    var currentFin: FinData?
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let fin = currentFin {
            finRangeLabel.text = fin.range
            if let repetition = fin.repetition.value {
                finRepetitionLabel.text = "\(repetition)"
            } else {
                repetitionLabel.text = ""
                finRepetitionLabel.text = ""
            }
        }
        
        deleteButton.setTitle(NSLocalizedString("Delete", comment: ""), for: .normal)
        
        Settings.settings.delegate = self
        Settings.setUI()
        
    }
    
    //MARK - FinData 종류 판별 함수
    
    func isStudyFin() -> Bool {
        return currentFin?.repetition.value == nil ? false : true
    }

    //MARK: - ToolBar 관련 함수
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: NSLocalizedString("Are you sure to delete?", comment: ""), message: NSLocalizedString("You cannot restore it.", comment: ""), preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive, handler: { (deleteAction) in
            
            self.delegate?.delete(self.currentFin!)
            self.navigationController?.popViewController(animated: true)
        
        })
        let preserveAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(preserveAction)
        
        present(alert, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = currentFin?.category
    }
    
    
}

//MARK: - SettingDelegate 관련 함수

extension FinInfoViewController: SettingDelegate {
    
    func adjustColor(){
        
        let repetition = currentFin?.repetition.value ?? 0
        let background = Settings.cellColors()[repetition]
        let tint = Settings.adjustTint(background)
        
        view.backgroundColor = background
        
        for i in allText {
            i.textColor = tint
        }
        
        buttonContainer.backgroundColor = Settings.background()
        deleteButton.setTitleColor(Settings.tint(), for: .normal)
        
    }
    
}
