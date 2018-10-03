//
//  BannerTableViewCell.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 03.10.18.
//  Copyright © 2018 Mathandoro GbR. All rights reserved.
//

import UIKit

class BannerTableViewCell: UITableViewCell {

    @IBOutlet weak var textLbl: UILabel!
    
    func configure(text: String, bgColor: UIColor, textColor: UIColor) {
        self.textLbl.text = text
        self.contentView.backgroundColor = bgColor
        self.textLbl.textColor = textColor
    }
    
}
