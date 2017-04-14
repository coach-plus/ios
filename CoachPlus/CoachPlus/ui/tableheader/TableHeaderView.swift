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
    
    var delegate:TableHeaderViewButtonDelegate?

    var showButton:Bool = false
    
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    @IBAction func btnTap(_ sender: Any) {
        if let dlg = self.delegate {
            dlg.tableViewHeaderBtnTap(sender)
        }
    }
    
    @IBInspectable var title: String {
        get {
            return self.titleView.text!
        }
        set(title) {
            self.titleView.text = title
        }
    }
    
    @IBInspectable var showBtn: Bool {
        get {
            return self.showBtn
        }
        set(show) {
            self.showBtn = show
            self.btn.isHidden = !self.showBtn
        }
    }
}

protocol TableHeaderViewButtonDelegate {
    func tableViewHeaderBtnTap(_ sender: Any)
}
