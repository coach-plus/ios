//
//  GradientView.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 24.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//
import Foundation
import UIKit

class GradientView: UIView {
    override open class var layerClass: AnyClass {
        get{
            return CAGradientLayer.classForCoder()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = [startColor().cgColor, endColor().cgColor]
    }
    
    func startColor() -> UIColor {
        return UIColor(hexString: "#52b0f0")
    }
    
    func endColor() -> UIColor {
        return UIColor(hexString: "265c7f")
    }
}
