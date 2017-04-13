//
//  TableHeader.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 31.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit

@IBDesignable class TableHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var titleView: UILabel!
    
    @IBInspectable var title: String {
        get {
            return self.titleView.text!
        }
        set(title) {
            self.titleView.text = title
        }
    }
    
    func setTitle(title:String) {
        self.titleView.text = title
    }
    
    
    func loadViewFromNib() -> UIView! {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TableHeader", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        view.backgroundColor = UIColor.white
        
        return view
    }
}
