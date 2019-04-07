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
import PromiseKit

class UserSettingsViewController: CoachPlusViewController {
    
    var user: User?
    
    @IBOutlet weak var verificationLbl: UILabel!
    
    @IBOutlet weak var verificationBtn: UIButton!
    
    @IBAction func verificationBtnTapped(_ sender: Any) {
    }
    
    @IBOutlet weak var verificationViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var personalHeader: TableHeaderView!
    
    @IBOutlet weak var firstnameTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lastnameTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var emailTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var savePersonalBtn: OutlineButton!
    
    @IBAction func savePersonalTapped(_ sender: Any) {
        self.checkAndSavePersonal()
    }
    
    @IBOutlet weak var changePwHeader: TableHeaderView!
    
    @IBOutlet weak var currentPwTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var newPwTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var repeatPwTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var changePwBtn: OutlineButton!
    
    @IBAction func changePwBtnTapped(_ sender: Any) {
        self.checkAndSavePassword()
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupVerification()
        
        self.setupNavBar()
        
        self.setupTextFields()
    }
    
    func setupVerification() {
        let isVerified = true
        if (isVerified) {
            self.verificationViewHeight.constant = 0
        } else {
            self.verificationLbl.text = "VERIFICATION_NOT_VERIFIED".localize()
            self.verificationBtn.setTitleForAllStates(title: "RESEND".localize())
        }
    }
    
    func setupNavBar() {
        
        self.setNavbarTitle(title: "UserSettings".localize())
        self.setLeftBarButton(type: .done)
 
    }
    
    
    
    func setupTextFields() {
        
        
        
        self.personalHeader.title = "USER_SETTINGS_PERSONAL".localize()
        self.personalHeader.showBtn = false
        
        self.firstnameTf.placeholder = "FIRSTNAME".localize()
        self.lastnameTf.placeholder = "LASTNAME".localize()
        self.emailTf.placeholder = "EMAIL".localize()
        
        self.firstnameTf.coachPlus()
        self.lastnameTf.coachPlus()
        self.emailTf.coachPlus()
        
        self.firstnameTf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.lastnameTf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.emailTf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        self.currentPwTf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.newPwTf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.repeatPwTf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        self.savePersonalBtn.setTitleForAllStates(title: "SAVE")
        self.savePersonalBtn.coachPlus()
        
        self.changePwHeader.title = "USER_SETTINGS_CHANGE_PW".localize()
        self.changePwHeader.showBtn = false
        
        self.currentPwTf.coachPlus()
        self.newPwTf.coachPlus()
        self.repeatPwTf.coachPlus()
        
        self.currentPwTf.placeholder = "USER_SETTINGS_CHANGE_PW_CURRENT_PLACEHOLDER"
        self.newPwTf.placeholder = "USER_SETTINGS_CHANGE_PW_NEW_PLACEHOLDER"
        self.repeatPwTf.placeholder = "USER_SETTINGS_CHANGE_PW_REPEAT_PLACEHOLDER"
        
        self.currentPwTf.isSecureTextEntry = true
        
        self.changePwBtn.setTitleForAllStates(title: "USER_SETTINGS_CHANGE_PW_BUTTON_TITLE")
        self.changePwBtn.coachPlus()
        
        self.showData()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case self.firstnameTf, self.lastnameTf, self.emailTf:
            self.checkPersonal()
            break
        case self.currentPwTf, self.newPwTf, self.repeatPwTf:
            self.checkPassword()
            break
        default:
            break
        }
    }

    
    func showData() {
        self.firstnameTf.text = self.user!.firstname
        self.lastnameTf.text = self.user!.lastname
        self.emailTf.text = self.user!.email
        
        self.checkPersonal()
    }
    
    func checkAndSavePersonal() {
        guard (self.checkPersonal()) else {
            return
        }
        
        self.loadData(text: "LOADING", promise: DataHandler.def.updateUserInfo(firstname: self.firstnameTf.text!, lastname: self.lastnameTf.text!, email: self.emailTf.text!)).done({ user in
            UserManager.storeUser(user: user)
            self.user = user
            UserManager.shared.userWasEdited.onNext(user)
        }).catch({err in
            
        })
    }
    
    func checkAndSavePassword() {
        guard (self.checkPassword()) else {
            return
        }
        
        self.loadData(text: "LOADING", promise: DataHandler.def.changePassword(oldPassword: self.currentPwTf.text!, newPassword: self.newPwTf.text!, newPasswordRepeat: self.repeatPwTf.text!)).done({ user in
            
        }).catch({err in
            
        })
    }
    
    func checkPersonal() -> Bool {
        let firstname = self.checkIfFieldIsFilled(self.firstnameTf)
        let lastname = self.checkIfFieldIsFilled(self.lastnameTf)
        let email = self.checkIfFieldContainsValidEmail(self.emailTf)
        
        return firstname && lastname && email
    }
    
    
    func checkPassword() -> Bool {
        let oldPw = self.checkIfFieldIsFilled(self.currentPwTf)
        let newPw = self.checkIfFieldIsFilled(self.newPwTf)
        let repeatPw = self.checkIfFieldIsFilled(self.repeatPwTf)
        
        let pwsAreEqual = (repeatPw && newPw && repeatPwTf.text == newPwTf.text)
        
        if (!pwsAreEqual) {
            repeatPwTf.errorMessage = "PASSWORDS_MUST_MATCH".localize()
        }
        
        return oldPw && pwsAreEqual
    }
    
    func checkIfFieldIsFilled(_ tf: SkyFloatingLabelTextField) -> Bool {
        if (tf.text != nil && tf.text!.count > 0) {
            tf.errorMessage = nil
            return true
        } else {
            tf.errorMessage = "PLEASE_FILL_IN_THIS_FIELD".localize()
            return false
        }
    }
    
    func checkIfFieldContainsValidEmail(_ tf: SkyFloatingLabelTextField) -> Bool {
        if (self.checkIfFieldIsFilled(tf) && tf.text!.isValidEmail) {
            tf.errorMessage = nil
            return true
        } else {
            tf.errorMessage = "PLEASE_ENTER_A_VALID_EMAIL".localize()
            return false
        }
    }

}
