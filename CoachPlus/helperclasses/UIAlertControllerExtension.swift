//
//  UIAlertControllerExtension.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 09.03.20.
//  Copyright © 2020 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {

    static func createCoachPlusAlert(title: String?, message: String?, style: UIAlertController.Style?) -> UIAlertController {
        
        var alertStyle = style ?? UIAlertController.Style.actionSheet
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
          alertStyle = UIAlertController.Style.alert
        }
        
        return UIAlertController(title: title, message: message, preferredStyle: alertStyle)
    }

}
