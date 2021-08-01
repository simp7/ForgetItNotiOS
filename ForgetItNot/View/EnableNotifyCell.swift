//
//  EnableBadgeCell.swift
//  ForgetItNot
//
//  Created by 박정현 on 11/08/2019.
//  Copyright © 2019 박정현. All rights reserved.
//

import Foundation

import UIKit

class EnableNotifyCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellSwitch: UISwitch!
    
    var delegate: EnableNotifyCellDelegate?
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        delegate?.turn(cellSwitch.isOn)
    }
    
}

protocol EnableNotifyCellDelegate {
    func turn(_ prev: Bool)
}
