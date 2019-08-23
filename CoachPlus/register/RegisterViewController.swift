//
//  RegisterViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 25.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON
import MBProgressHUD
import Alamofire

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var firstnameLbl: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lastnameLbl: SkyFloatingLabelTextField!
    
    @IBOutlet weak var emailLbl: SkyFloatingLabelTextField!
    
    @IBOutlet weak var passwordLbl: SkyFloatingLabelTextField!
    
    @IBOutlet weak var repeatPasswordLbl: SkyFloatingLabelTextField!
    
    @IBOutlet weak var signInBtn: OutlineButton!
    
    @IBOutlet weak var termsToggle: UISwitch!
    
    @IBOutlet weak var dataPrivacyToggle: UISwitch!
    
    @IBOutlet weak var termsText: UILabel!
    
    @IBOutlet weak var dataPrivacyText: UILabel!
    var hud:MBProgressHUD?
    
    @IBOutlet weak var termsButton: UIButton!
    
    @IBOutlet weak var dataPrivacyButton: UIButton!
    
    @IBAction func termsBtnTapped(_ sender: Any) {
        self.openWebpage(urlString: CoachPlus.termsUrl)
    }
    
    @IBAction func dataPrivacyBtnTapped(_ sender: Any) {
        self.openWebpage(urlString: CoachPlus.dataPrivacyUrl)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        self.register()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailLbl.errorColor = UIColor.coachPlusLightRed
        self.backBtn.setCoachPlusIcon(fontType: .fontAwesomeSolid(.arrowLeft), color: .white, size: 20.0)
        
        self.signInBtn.setTitleForAllStates(title: L10n.register)
        
        self.firstnameLbl.placeholder = L10n.firstname
        self.lastnameLbl.placeholder = L10n.lastname
        self.emailLbl.placeholder = L10n.email
        self.passwordLbl.placeholder = L10n.password
        self.repeatPasswordLbl.placeholder = L10n.repeatPassword
        
        self.termsText.text = L10n.iAgreeToTheTermsAndConditions
        self.dataPrivacyText.text = L10n.iAgreeToTheDataprivacyPolicy
        
        self.termsText.textColor = .white
        self.dataPrivacyText.textColor = .white
        
        self.termsButton.setCoachPlusIcon(fontType: .fontAwesomeSolid(.externalLinkAlt), color: .white, size: 15.0)
        self.dataPrivacyButton.setCoachPlusIcon(fontType: .fontAwesomeSolid(.externalLinkAlt), color: .white, size: 15.0)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldIsValid(_ skyTextField: SkyFloatingLabelTextField) -> Bool {
        return self.textFieldIsValid(skyTextField, newText: nil)
    }
    
    func textFieldIsValid(_ skyTextField: SkyFloatingLabelTextField, newText:String?) -> Bool {
        
        var text = ""
        
        if (newText != nil) {
            text = newText!
        } else if (skyTextField.text != nil) {
            text = skyTextField.text!
        }
        
        var errorMessage = ""
        
        switch skyTextField {
        case self.firstnameLbl,
             self.lastnameLbl,
             self.passwordLbl:
            if (text.characters.count == 0) {
                errorMessage = L10n.pleaseFillInThisField
            }
            break
            
        case self.emailLbl:
            if (!text.isValidEmail) {
                errorMessage = L10n.pleaseEnterYourEmailAddress
            }
        case self.repeatPasswordLbl:
            if (text != self.passwordLbl.text) {
                errorMessage = L10n.passwordsMustMatch
            }
        default: break
        }
        
        skyTextField.errorMessage = errorMessage
        
        return (errorMessage.characters.count == 0)

    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let skyTextField = textField as! SkyFloatingLabelTextField
        
        if var text = skyTextField.text {
            let nsString = text as NSString
            text = nsString.replacingCharacters(in: range, with: string)
            
            _ = self.textFieldIsValid(skyTextField, newText: text)
        }
        
        return true
    }
    
    func validateInputs() -> Bool {
        return (
            self.textFieldIsValid(self.firstnameLbl) &&
            self.textFieldIsValid(self.lastnameLbl) &&
            self.textFieldIsValid(self.emailLbl) &&
            self.textFieldIsValid(self.passwordLbl) &&
            self.textFieldIsValid(self.repeatPasswordLbl))
    }
    
    func register() {
        
        if (!self.validateInputs()) {
            return
        }
        
        let termsAccepted = self.termsToggle.isOn
        let dataPrivacyAccepted = self.dataPrivacyToggle.isOn
        
        if (termsAccepted != true) {
            DropdownAlert.error(message: L10n.youMustAgreeToTheTermsAndConditions)
            return
        }
        
        if (dataPrivacyAccepted != true) {
            DropdownAlert.error(message: L10n.youMustAgreeToTheDataprivacyPolicy)
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = L10n.loading
        hud.label.textColor = UIColor.white
        
        DataHandler.def.register(firstname: self.firstnameLbl.text!, lastname: self.lastnameLbl.text!, email: self.emailLbl.text!, password: self.passwordLbl.text!, termsAccepted: termsAccepted, dataPrivacyAccepted: dataPrivacyAccepted).done({ apiResponse in
            self.showDone(hud: hud)
            self.registerSuccessful()
        }).catch({ err in
            hud.hide(animated: true)
        })
        
    }
    
    func showDone(hud:MBProgressHUD) {
        
        let checkLbl = UILabel()
        checkLbl.setIcon(icon: .fontAwesomeSolid(.check), iconSize: 40)
        checkLbl.textColor = UIColor.white
        
        hud.mode = MBProgressHUDMode.customView
        hud.customView = checkLbl
        hud.isSquare = true
        hud.label.text = L10n.done
        hud.label.textColor = UIColor.white
        
    }
    
    func registerSuccessful() {
        self.performSegue(withIdentifier: "goToMailSent", sender: nil)
    }
    
    
    
}

