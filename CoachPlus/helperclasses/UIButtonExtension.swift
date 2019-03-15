//
//  UIButtonExtension.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 15.03.19.
//  Copyright © 2019 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func setTitleForAllStates(title: String) {
        let localizedTitle = title.localize()
        self.setTitle(localizedTitle, for: .normal)
        self.setTitle(localizedTitle, for: .focused)
        self.setTitle(localizedTitle, for: .highlighted)
        self.setTitle(localizedTitle, for: .selected)
    }
}
