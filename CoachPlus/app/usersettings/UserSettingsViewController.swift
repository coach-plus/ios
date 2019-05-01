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
        self.resendVerificationEmail()
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
        
        self.setup()
        
        
        self.loadData(text: nil, promise: DataHandler.def.getUser()).done({user in
            self.user = user
            self.showUserData()
        })
    }
    
    func setup() {
        self.setupNavBar()
        self.setupTextFields()
    }
    
    func setupVerification() {
        let isVerified = self.user?.emailVerified ?? false
        if (isVerified) {
            self.verificationViewHeight.constant = 0
        } else {
            self.verificationLbl.text = L10n.youAreNotVerified
            self.verificationBtn.setTitleForAllStates(title: L10n.resendEMail)
        }
    }
    
    func setupNavBar() {
        
        self.setNavbarTitle(title: L10n.userSettings)
        self.setLeftBarButton(type: .done)
 
    }
    
    
    
    func setupTextFields() {
        self.personalHeader.title = L10n.personalSettings
        self.personalHeader.showBtn = false
        
        self.firstnameTf.placeholder = L10n.firstname
        self.lastnameTf.placeholder = L10n.lastname
        self.emailTf.placeholder = L10n.email
        
        self.firstnameTf.coachPlus()
        self.lastnameTf.coachPlus()
        self.emailTf.coachPlus()
        
        self.firstnameTf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.lastnameTf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.emailTf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        self.currentPwTf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.newPwTf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.repeatPwTf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        self.savePersonalBtn.setTitleForAllStates(title: L10n.save)
        self.savePersonalBtn.coachPlus()
        
        self.changePwHeader.title = L10n.changePassword
        self.changePwHeader.showBtn = false
        
        self.currentPwTf.coachPlus()
        self.newPwTf.coachPlus()
        self.repeatPwTf.coachPlus()
        
        self.currentPwTf.placeholder = L10n.oldPassword
        self.newPwTf.placeholder = L10n.newPassword
        self.repeatPwTf.placeholder = L10n.repeatNewPassword
        
        self.currentPwTf.isSecureTextEntry = true
        self.newPwTf.isSecureTextEntry = true
        self.repeatPwTf.isSecureTextEntry = true
        
        self.changePwBtn.setTitleForAllStates(title: L10n.changePassword)
        self.changePwBtn.coachPlus()
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

    
    func showUserData() {
        self.firstnameTf.text = self.user!.firstname
        self.lastnameTf.text = self.user!.lastname
        self.emailTf.text = self.user!.email
        self.setupVerification()
        self.checkPersonal()
    }
    
    func checkAndSavePersonal() {
        guard (self.checkPersonal()) else {
            return
        }
        
        self.loadData(text: L10n.loading, promise: DataHandler.def.updateUserInfo(firstname: self.firstnameTf.text!, lastname: self.lastnameTf.text!, email: self.emailTf.text!)).done({ user in
            UserManager.storeUser(user: user)
            self.user = user
            UserManager.shared.userWasEdited.onNext(user)
            DropdownAlert.success(message: L10n.saved)
        })
    }
    
    func checkAndSavePassword() {
        guard (self.checkPassword()) else {
            return
        }
        
        self.loadData(text: L10n.loading, promise: DataHandler.def.changePassword(oldPassword: self.currentPwTf.text!, newPassword: self.newPwTf.text!, newPasswordRepeat: self.repeatPwTf.text!)).done({ user in
            DropdownAlert.success(message: L10n.saved)
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
            repeatPwTf.errorMessage = L10n.passwordsMustMatch
        }
        
        return oldPw && pwsAreEqual
    }
    
    func checkIfFieldIsFilled(_ tf: SkyFloatingLabelTextField) -> Bool {
        if (tf.text != nil && tf.text!.count > 0) {
            tf.errorMessage = nil
            return true
        } else {
            tf.errorMessage = L10n.pleaseFillInThisField
            return false
        }
    }
    
    func checkIfFieldContainsValidEmail(_ tf: SkyFloatingLabelTextField) -> Bool {
        if (self.checkIfFieldIsFilled(tf) && tf.text!.isValidEmail) {
            tf.errorMessage = nil
            return true
        } else {
            tf.errorMessage = L10n.pleaseEnterYourEmailAddress
            return false
        }
    }

    func resendVerificationEmail() {
        self.loadData(text: L10n.loading, promise: DataHandler.def.resendVerificationEmail()).done({ response in
            DropdownAlert.success(message: L10n.confirmationEmailSent)
        })
    }
}
