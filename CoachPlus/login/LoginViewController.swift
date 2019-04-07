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

class LoginViewController: UIViewController {

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
        
        self.emailTf.placeholder = "EMAIL".localize()
        self.passwordTf.placeholder = "PASSWORD".localize()
        
        self.loginBtn.setTitleForAllStates(title: "LOGIN".localize())
        self.registerBtn.setTitleForAllStates(title: "REGISTER".localize())
        self.forgotPwBtn.setTitleForAllStates(title: "FORGOT_PW".localize())
    }
    
    func goToForgotPw() {
        self.openWebpage(urlString: CoachPlus.registerUrl)
    }
    
    func signIn() {
        let email = self.emailTf.text!
        let password = self.passwordTf.text!
        
        let hud = MBProgressHUD.createHUD(view: self.view, msg: "LOGIN".localize())
        
        DataHandler.def.login(email: email, password: password).done({ apiResponse in
            
            DataHandler.def.getMyMemberships().done({ memberships in
                hud.hide(animated: true)
                
                FlowManager.goToHome(sourceVc: self)
                
            }).catch({ err in
                hud.hide(animated: true)
                FlowManager.goToHome(sourceVc: self)
            })
        }).catch({ err in
            hud.hide(animated: true)
            DropdownAlert.error(message: err.localizedDescription)
        })
        
    }
}
