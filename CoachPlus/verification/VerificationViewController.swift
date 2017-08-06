//
//  VerificationViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 24.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import MBProgressHUD

class VerificationViewController: UIViewController {

    var token:String = ""
    
    @IBOutlet weak var resultView: UIView!
    
    @IBOutlet weak var iconLbl: UILabel!
    
    @IBOutlet weak var textLbl: UILabel!
    
    
    @IBAction func continueTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textLbl.text = ""
        self.iconLbl.text = ""
        
        self.resultView.isHidden = true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        verifyToken()
        
    }
    
    func verifyToken() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Verififying.."
        
        _ = DataHandler.def.verifyToken(token: self.token, successHandler: {
            self.textLbl.text = "You are now verified."
            self.iconLbl.setIcon(icon: .fontAwesome(.check), iconSize: 60)
            self.resultView.isHidden = false
            hud.hide(animated: true)
            
        }, failHandler: { apiResponse in
            self.textLbl.text = "Verification failed."
            self.iconLbl.setIcon(icon: .fontAwesome(.times), iconSize: 60)
            self.resultView.isHidden = false
            hud.hide(animated: true)
        })
    }

}
