//
//  UIColorExtension.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 24.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString:String) {
        let hexString:NSString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
        let scanner            = Scanner(string: hexString as String)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return NSString(format:"#%06x", rgb) as String
    }
    
    func lighterColor(percent : Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 + percent));
    }
    
    func darkerColor(percent : Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 - percent));
    }
    
    func colorWithBrightnessFactor(factor: CGFloat) -> UIColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return self;
        }
    }
    
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        let ctx = UIGraphicsGetCurrentContext()
        self.setFill()
        ctx!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    static var coachPlusBlue:UIColor {
        get {
            return UIColor(named: "CoachPlusBlue")!
        }
    }
    
    static var coachPlusTeamPublicIndicator:UIColor {
        get {
            return UIColor(named: "CoachPlusTeamPublicIndicator")!
        }
    }
    
    static var coachPlusGrey:UIColor {
        get {
            return UIColor(hexString: "#4a4a4a")
        }
    }
    
    static var coachPlusLightGrey:UIColor {
        get {
            return UIColor(hexString: "#9b9b9b")
        }
    }
    
    static var coachPlusBackgroundColor:UIColor {
        get {
            return UIColor.white
        }
    }
    
    static let coachPlusParticipationYesColor = UIColor(hexString: "#73ba26")
    static let coachPlusParticipationNoColor = UIColor.coachPlusRedColor
    
    static let coachPlusParticipationDidNotAttendColor = UIColor.orange
    
    static let coachPlusRedColor = UIColor(hexString: "#FF3B30")
    static let coachPlusLightRed = UIColor(hexString: "#a72c38")
    
    static let coachPlusParticipationWrongColor = UIColor.coachPlusRedColor // UIColor(hexString: "#F5DEDE")
    
    static let coachPlusBannerBackgroundColor = UIColor.coachPlusLightBlue // UIColor(hexString: "#DCE3E8")
    
    static let unselectedColor = UIColor(hexString: "9b9b9b")
    
    static let leaveTeamRed = UIColor(hexString: "dc3545")
    
    static let coachPlusLightBlue = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 0.1)
}
