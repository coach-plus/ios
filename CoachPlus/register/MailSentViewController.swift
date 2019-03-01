//
//  MailSentViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 25.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import Foundation

class MailSentViewController: UIViewController {

    @IBOutlet weak var iconLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconLabel?.setIcon(icon: .fontAwesomeSolid(.paperPlane), iconSize: 60)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        FlowManager.goToHome(sourceVc: self)
    }

}
