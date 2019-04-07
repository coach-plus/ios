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

class ForgotPwViewController: UIViewController {

    @IBOutlet weak var emailTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var requestBtn: OutlineButton!
    
    @IBOutlet weak var logoIv: UIImageView!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBAction func requestBtnTapped(_ sender: Any) {
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        self.hero.isEnabled = true
        
        self.emailTf.hero.isEnabled = true
        self.emailTf.hero.id = "email"
        
        self.logoIv.hero.isEnabled = true
        self.logoIv.hero.id = "launchLogo"
        
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
}
