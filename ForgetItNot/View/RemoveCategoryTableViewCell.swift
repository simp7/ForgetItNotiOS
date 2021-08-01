//
//  RemoveNameTableViewCell.swift
//  ForgetItNot
//
//  Created by 박정현 on 06/08/2019.
//  Copyright © 2019 박정현. All rights reserved.
//

import UIKit

class RemoveCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var picker: RemoveCategoryPickerView!
    
    var delegate: removeCategoryCellDelegate?
    
    @IBAction func removeButtonPressed(_ sender: UIButton) {
        delegate?.removeCategory(picker.selectedRow(inComponent: 0))
    }

}

protocol removeCategoryCellDelegate {
    func removeCategory(_ row: Int)
}
