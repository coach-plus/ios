//
//  LoginViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 23.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        self.goToRegister()
    }
    
    
    @IBAction func forgotPwTapped(_ sender: Any) {
        goToForgotPw()
    }
    
    func goToRegister() {
        self.openWebpage(urlString: CoachPlus.registerUrl)
    }
    
    func goToForgotPw() {
        self.openWebpage(urlString: CoachPlus.registerUrl)
    }
    
    func openWebpage(urlString:String) {
        let url = URL(string: urlString)!
        
        let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
        present(vc, animated: true, completion: nil)
    }
}
