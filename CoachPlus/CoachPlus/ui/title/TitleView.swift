//
//  TitleView.swift
//  CoachPlus
//
//  Created by Maurice Breit on 17.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import NibDesignable

class TitleView: NibDesignable {
    
    @IBOutlet weak var titleLbl: UILabel!
    

    @IBInspectable var title: String {
        get {
            return self.titleLbl.text!
        }
        set(title) {
            self.titleLbl.text = title.uppercased()
        }
    }
    
}
