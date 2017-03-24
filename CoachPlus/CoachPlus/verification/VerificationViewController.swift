//
//  VerificationViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 24.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit

class VerificationViewController: UIViewController {

    var token:String = ""
    
    @IBOutlet weak var tokenLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tokenLbl.text = self.token
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
