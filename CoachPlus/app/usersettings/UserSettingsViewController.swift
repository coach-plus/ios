//
//  UserSettingsViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 09.03.19.
//  Copyright © 2019 Mathandoro GbR. All rights reserved.
//

import UIKit

class UserSettingsViewController: CoachPlusViewController {

    override func viewDidLoad() {
        self.setupNavBar()
    }
    
    func setupNavBar() {
        self.setNavbarTitle(title: "UserSettings".localize())
        
        self.setLeftBarButton(type: .done)
    }

}
