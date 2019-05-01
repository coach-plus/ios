//
//  LoginViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 23.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import SafariServices
import SkyFloatingLabelTextField
import MBProgressHUD

class LoginViewController: CoachPlusViewController {

    @IBOutlet weak var emailTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var passwordTf: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: OutlineButton!
    @IBOutlet weak var forgotPwBtn: UIButton!
    
    @IBAction func signInTapped(_ sender: Any) {
        self.signIn()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTf.placeholder = L10n.email
        self.passwordTf.placeholder = L10n.password
        
        self.loginBtn.setTitleForAllStates(title: L10n.login)
        self.registerBtn.setTitleForAllStates(title: L10n.register)
        self.forgotPwBtn.setTitleForAllStates(title: L10n.forgotPassword)
    }
    
    func goToForgotPw() {
        self.openWebpage(urlString: CoachPlus.registerUrl)
    }
    
    func signIn() {
        let email = self.emailTf.text!
        let password = self.passwordTf.text!
        
        
        self.loadData(text: L10n.loading, promise: DataHandler.def.login(email: email, password: password)).done({ apiResponse in
            
            DataHandler.def.getMyMemberships().done({ memberships in
                FlowManager.goToHome(sourceVc: self)
            }).catch({ err in
                FlowManager.goToHome(sourceVc: self)
            })
        })
        
    }
}
