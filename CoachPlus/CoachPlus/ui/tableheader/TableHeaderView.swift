//
//  TableHeader.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 31.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import NibDesignable

@IBDesignable
class TableHeaderView: NibDesignable {

    @IBOutlet weak var titleView: UILabel!
    
    @IBInspectable var title: String {
        get {
            return self.titleView.text!
        }
        set(title) {
            self.titleView.text = title
        }
    }
}
