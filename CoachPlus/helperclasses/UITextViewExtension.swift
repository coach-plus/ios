//
//  UITextViewExtension.swift
//  CoachPlus
//
//  Created by Maurice Breit on 04.08.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    
    func fixPadding() {
        self.textContainerInset = .zero;
        self.textContainer.lineFragmentPadding = 0;
    }
}

