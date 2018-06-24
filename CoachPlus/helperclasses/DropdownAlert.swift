//
//  DropdownAlert.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 26.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import RKDropdownAlert

class DropdownAlert {
    
    static let errorBgColor = UIColor.red
    static let errorTextColor = UIColor.white
    static let errorTitle = "Error"
    static let errorTime = 3
    
    static func error(message: String?) {
        let msg = message?.localize()
        RKDropdownAlert.title(errorTitle, message: msg, backgroundColor: errorBgColor, textColor: errorTextColor, time: errorTime)
    }
    
    
}
