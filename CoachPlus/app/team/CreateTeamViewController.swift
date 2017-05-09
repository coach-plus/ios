//
//  CreateTeamViewController.swift
//  CoachPlus
//
//  Created by Maurice Breit on 08.05.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class CreateTeamViewController: CoachPlusViewController {

    @IBOutlet weak var nameTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var createBtn: OutlineButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func createBtnTapped(_ sender: Any) {
        
        let teamName = self.nameTf.text
        
        let isPublic = true
        
        DataHandler.def.createTeam(createTeam: [
            "name": teamName,
            "isPublic": isPublic
            ], successHandler: { response in
                self.dismiss(animated: true, completion: nil)
        }, failHandler: { err in
            print(err)
        })
    }

}
