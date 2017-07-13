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
import RKDropdownAlert

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstnameLbl: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lastnameLbl: SkyFloatingLabelTextField!
    
    @IBOutlet weak var emailLbl: SkyFloatingLabelTextField!
    
    @IBOutlet weak var passwordLbl: SkyFloatingLabelTextField!
    
    @IBOutlet weak var repeatPasswordLbl: SkyFloatingLabelTextField!
    
    @IBOutlet weak var signInBtn: OutlineButton!
    
    var hud:MBProgressHUD?
    
    @IBAction func signUpTapped(_ sender: Any) {
        self.register()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                errorMessage = "Please fill out this field"
            }
            break
            
        case self.emailLbl:
            if (!text.isValidEmail) {
                errorMessage = "Invalid E-Mail Address"
            }
        case self.repeatPasswordLbl:
            if (text != self.passwordLbl.text) {
                errorMessage = "Passwords do not match"
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
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Registering.."
        hud.label.textColor = UIColor.white
        
        
        _ = DataHandler.def.register(firstname: self.firstnameLbl.text!, lastname: self.lastnameLbl.text!, email: self.emailLbl.text!, password: self.passwordLbl.text!, successHandler: { _ in
            self.showDone(hud: hud)
            self.registerSuccessful()
        }, failHandler: { apiResponse in
            hud.hide(animated: true)
            DropdownAlert.error(message: apiResponse.message)
        })
        
    }
    
    func showDone(hud:MBProgressHUD) {
        
        let checkLbl = UILabel()
        checkLbl.font = UIFont.fontAwesome(ofSize: 40)
        checkLbl.text = String.fontAwesomeIcon(name: .check)
        checkLbl.textColor = UIColor.white
        
        hud.mode = MBProgressHUDMode.customView
        hud.customView = checkLbl
        hud.isSquare = true
        hud.label.text = "Done"
        hud.label.textColor = UIColor.white
        
    }
    
    func registerSuccessful() {
        self.performSegue(withIdentifier: "goToMailSent", sender: nil)
    }
    
    
    
}

