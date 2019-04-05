//
//  UserSettingsViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 09.03.19.
//  Copyright © 2019 Mathandoro GbR. All rights reserved.
//

import UIKit
import Eureka
import SkyFloatingLabelTextField

class UserSettingsViewController: CoachPlusViewController {
    
    @IBOutlet weak var changePwHeader: TableHeaderView!
    
    @IBOutlet weak var currentPwTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var newPwTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var repeatPwTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var changePwBtn: OutlineButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupNavBar()
        
        self.setupTextFields()
        
        self.changePwBtn.setTitleForAllStates(title: "USER_SETTINGS_CHANGE_PW_BUTTON_TITLE")
    }
    
    func setupNavBar() {
        
        self.setNavbarTitle(title: "UserSettings".localize())
        self.setLeftBarButton(type: .done)
 
    }
    
    func setupTextFields() {
        
        self.changePwHeader.title = "USER_SETTINGS_CHANGE_PW"
        self.changePwHeader.showBtn = false
        
        self.currentPwTf.coachPlus()
        self.newPwTf.coachPlus()
        self.repeatPwTf.coachPlus()
        
        self.currentPwTf.placeholder = "USER_SETTINGS_CHANGE_PW_CURRENT_PLACEHOLDER"
        self.newPwTf.placeholder = "USER_SETTINGS_CHANGE_PW_NEW_PLACEHOLDER"
        self.repeatPwTf.placeholder = "USER_SETTINGS_CHANGE_PW_REPEAT_PLACEHOLDER"
        
        self.currentPwTf.isSecureTextEntry = true
    }

}
