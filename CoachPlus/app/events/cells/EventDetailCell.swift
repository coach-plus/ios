//
//  EditableTableViewCell.swift
//  CoachPlus
//
//  Created by Maurice Breit on 23.06.18.
//  Copyright © 2018 Mathandoro GbR. All rights reserved.
//

import UIKit

class EditableTableViewCell: UITableViewCell {
    
    enum Mode {
        case Label
        case EditText
    }
    
    var event: Event?
    
    var showIcon: Bool = true
    var icon: UIImage?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func onSelect() {
        
    }
    
    
}
