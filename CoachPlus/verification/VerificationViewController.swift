//
//  VerificationViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 24.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit

class VerificationViewController: CoachPlusViewController {

    var token:String = ""
    
    @IBOutlet weak var resultView: UIView!
    
    @IBOutlet weak var iconLbl: UILabel!
    
    @IBOutlet weak var textLbl: UILabel!
    
    @IBOutlet weak var continueBtn: OutlineButton!
    
    @IBAction func continueTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textLbl.text = ""
        self.iconLbl.text = ""
        self.iconLbl.textColor = .white
        self.continueBtn.tintColor = .white
        self.continueBtn.setup()
        self.continueBtn.setTitleForAllStates(title: "CONTINUE")
        
        self.resultView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        verifyToken()
    }
    
    func verifyToken() {
        self.loadData(text: "LOAD_DATA", promise: DataHandler.def.verifyToken(token: self.token)).done({ response in
            self.textLbl.text = "You are now verified."
            self.iconLbl.setIcon(icon: .fontAwesomeSolid(.check), iconSize: 60, color: .white, bgColor: .clear)
            self.resultView.isHidden = false
        }).catch({ err in
            self.textLbl.text = "Verification failed."
            self.iconLbl.setIcon(icon: .fontAwesomeSolid(.times), iconSize: 60, color: .coachPlusLightRed, bgColor: .clear)
            self.resultView.isHidden = false
        })
    }

}
