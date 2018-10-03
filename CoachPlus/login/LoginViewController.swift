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
        
        DataHandler.def.login(email: email, password: password).done({ apiResponse in
            
            DataHandler.def.getMyMemberships().done({ memberships in
                
                FlowManager.goToHome(sourceVc: self)
                
            }).catch({ err in
                FlowManager.goToHome(sourceVc: self)
            })
        }).catch({ err in
            //DropdownAlert.error(message: err)
        })
        
    }
}
