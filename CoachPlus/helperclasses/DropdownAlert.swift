//
//  DropdownAlert.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 26.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import NotificationBannerSwift

class DropdownAlert {
    
    static let errorBgColor = UIColor.red
    static let errorTextColor = UIColor.white
    static let errorTitle = L10n.error
    static let errorTime = 3
    
    static let successTitle = L10n.success
    
    static func error(message: String) {
        let msg = message.localize()
        let banner = NotificationBanner(title: self.errorTitle, subtitle: msg, style: .danger)
        banner.show()
    }
    
    static func success(message: String) {
        let banner = NotificationBanner(title: self.successTitle, subtitle: message, style: .success)
        banner.show()
    }
    
    
}
