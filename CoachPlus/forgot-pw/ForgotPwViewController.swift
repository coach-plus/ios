//
//  ForgotPwViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 06.04.19.
//  Copyright © 2019 Mathandoro GbR. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftIcons
import Hero
import MBProgressHUD

class ForgotPwViewController: UIViewController, ErrorHandlerDelegate {

    @IBOutlet weak var emailTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var requestBtn: OutlineButton!
    
    @IBOutlet weak var logoIv: UIImageView!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    var errorHandler: ErrorHandler?
    
    @IBAction func requestBtnTapped(_ sender: Any) {
        self.requestNewPassword()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        self.errorHandler = ErrorHandler(delegate: self)
        
        self.hero.isEnabled = true
        
        self.emailTf.hero.isEnabled = true
        self.emailTf.hero.id = "email"
        
        self.logoIv.hero.isEnabled = true
        self.logoIv.hero.id = "launchLogo"
        
        self.requestBtn.setTitleForAllStates(title: "REQUEST_NEW_PW")
        self.requestBtn.tintColor = .white
        self.requestBtn.setup()
        
        self.backBtn.tintColor = .white
        self.backBtn.setCoachPlusIcon(fontType: .fontAwesomeSolid(.arrowLeft), color: .white, size: 20.0)
        
        self.descriptionLbl.text = "FORGOT_PW_DESCRIPTION".localize()
        self.emailTf.placeholder = "EMAIL".localize()
        
        self.emailTf.textColor = .white
        self.emailTf.placeholderColor = .white
        self.emailTf.tintColor = .white
        self.emailTf.lineColor = .white
        self.emailTf.selectedLineColor = .white
        self.emailTf.selectedTitleColor = .white
    }
    
    func requestNewPassword() {
        let email = self.emailTf.text
        if (email == nil || email?.count == 0 || !email!.isValidEmail) {
            DropdownAlert.error(message: "PLEASE_ENTER_A_VALID_EMAIL")
            return
        }
        
        let hud = MBProgressHUD.createHUD(view: self.view, msg: "REQUESTING_NEW_PASSWORD")
        
        DataHandler.def.requestNewPassword(email: email!).done({response in
            DropdownAlert.success(message: "REQUEST_NEW_PASSWORD_SUCCESS")
            self.dismiss(animated: true, completion: nil)
        }).ensure {
            hud.hide(animated: true)
        }.catch({ error in self.errorHandler?.handleError(error: error)})
        
    }
}
