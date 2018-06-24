//
//  UITextViewExtension.swift
//  CoachPlus
//
//  Created by Maurice Breit on 04.08.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

extension UITextView {
    
    func fixPadding() {
        self.textContainerInset = .zero;
        self.textContainer.lineFragmentPadding = 0;
    }
}

extension SkyFloatingLabelTextField {
    
    func coachPlusFormatter(title:String) -> String {
        return title
    }
    
    func coachPlus() {
        self.tintColor = UIColor.coachPlusBlue
        self.textColor = UIColor.coachPlusBlue
        self.selectedTitleColor = UIColor.coachPlusBlue
        self.selectedLineColor = UIColor.coachPlusBlue
        self.lineColor = UIColor.coachPlusGrey
        
        self.titleFormatter = self.coachPlusFormatter
    }
    

    
}
