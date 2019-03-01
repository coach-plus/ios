//
//  UIButtonExtension.swift
//  CoachPlus
//
//  Created by Maurice Breit on 18.02.18.
//  Copyright © 2018 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit
import SwiftIcons

extension UIButton {
    func setCoachPlusIcon(fontType: FontType, color: UIColor? = .coachPlusGrey, size: CGFloat? = 20) {
        self.setIcon(icon: fontType, iconSize: size, color: color!, backgroundColor: .clear, forState: .normal)
        self.setIcon(icon: fontType, iconSize: size, color: color!, backgroundColor: .clear, forState: .selected)
        self.setIcon(icon: fontType, iconSize: size, color: color!, backgroundColor: .clear, forState: .highlighted)
    }
}

extension UIBarButtonItem {
    func setCoachPlusIcon(fontType: FontType, color: UIColor) {
        self.setIcon(icon: fontType, iconSize: 20, color: color)
    }
}
