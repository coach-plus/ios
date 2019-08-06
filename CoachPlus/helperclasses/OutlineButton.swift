//
//  OutlineButton.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 24.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit

@IBDesignable
class OutlineButton: UIButton {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor.clear
        self.layer.borderWidth = 1
        self.layer.borderColor = self.tintColor.cgColor
        self.layer.cornerRadius = self.bounds.height / 2
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.setTitleForAllStates(title: self.title(for: .normal) ?? "")
    }
    
    func coachPlus() {
        self.tintColor = UIColor.coachPlusBlue
        self.setup()
    }

}
