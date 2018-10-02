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

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var passwordTf: SkyFloatingLabelTextField!
    
    @IBAction func signInTapped(_ sender: Any) {
        self.signIn()
    }
    
    @IBAction func forgotPwTapped(_ sender: Any) {
        goToForgotPw()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func goToForgotPw() {
        self.openWebpage(urlString: CoachPlus.registerUrl)
    }
    
    func signIn() {
        let email = self.emailTf.text!
        let password = self.passwordTf.text!
        
        MBProgressHUD.createHUD(view: self.view, msg: "LOGIN".localize())
        
        _ = DataHandler.def.login(email: email, password: password, successHandler: { apiResponse in
            
            _ = DataHandler.def.getMyMemberships(successHandler: { memberships in
                
                FlowManager.goToHome(sourceVc: self)
                
            }, failHandler: { apiResponse in
                FlowManager.goToHome(sourceVc: self)
            })
            
            
            
            
        }, failHandler: { apiResponse in
            DropdownAlert.error(message: apiResponse.message)
        })
        
    }
}
