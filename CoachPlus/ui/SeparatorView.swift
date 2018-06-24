//
//  SeparatorView.swift
//  CoachPlus
//
//  Created by Maurice Breit on 23.06.18.
//  Copyright © 2018 Mathandoro GbR. All rights reserved.
//

import UIKit

class SeparatorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.coachPlusBlue
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
