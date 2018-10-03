//
//  JoinTeamViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 09.05.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit


class JoinTeamViewController: CoachPlusViewController {
    
    enum TeamType {
        case publicTeam
        case privateTeam
    }

    var inviteId:String?
    var mode:TeamType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(self.inviteId!)
        self.joinTeam()
    }
    
    func joinTeam() {
        
        guard self.inviteId != nil && self.mode != nil else {
            return
        }
        
        self.loadData(text: "LOAD_DATA", promise: DataHandler.def.joinTeam(inviteId: self.inviteId!, teamType: self.mode!)).done({ apiResponse in
            self.dismiss(animated: true, completion: nil)
        }).catch({ err in
            print(err)
        })
    }
    
    
    
    
    
    
}
