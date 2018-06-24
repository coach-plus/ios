//
//  UIViewExtension.swift
//  CoachPlus
//
//  Created by Maurice Breit on 23.02.18.
//  Copyright © 2018 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
