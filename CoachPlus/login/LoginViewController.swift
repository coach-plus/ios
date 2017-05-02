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
    
    func openWebpage(urlString:String) {
        let url = URL(string: urlString)!
        
        let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
        present(vc, animated: true, completion: nil)
    }
    
    func signIn() {
        let email = self.emailTf.text!
        let password = self.passwordTf.text!
        
        _ = DataHandler.def.login(email: email, password: password, successHandler: { apiResponse in
            
            FlowManager.presentHome(sourceVc: self)
            
        }, failHandler: { apiResponse in
            DropdownAlert.error(message: apiResponse.message)
        })
        
    }
}
