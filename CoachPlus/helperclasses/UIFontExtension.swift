//
//  UIFontExtension.swift
//  CoachPlus
//
//  Created by Maurice Breit on 23.02.18.
//  Copyright © 2018 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit

class FontManager {
    static func getFontname(fontNameToTest:String) -> String {
        let fontNameToTest = fontNameToTest.lowercased();
        var fontName = "Roboto";
        if fontNameToTest.range(of: "bold") != nil {
            fontName += "-Bold";
        } else if fontNameToTest.range(of: "medium") != nil {
            fontName += "-Medium";
        } else if fontNameToTest.range(of: "light") != nil {
            fontName += "-Light";
        } else if fontNameToTest.range(of: "ultralight") != nil {
            fontName += "-UltraLight";
        }
        return fontName
    }
}

extension UILabel {
    func setCoachPlusFont() {
        self.font = UIFont(name: FontManager.getFontname(fontNameToTest: self.font.fontName), size: self.font.pointSize)
    }
}
