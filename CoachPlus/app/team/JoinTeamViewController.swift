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

    @IBOutlet weak var textLbl: UILabel!
    
    var inviteId:String?
    var mode:TeamType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textLbl.text = L10n.joiningTeam
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.joinTeam()
    }
    
    func joinTeam() {
        
        guard self.inviteId != nil && self.mode != nil else {
            return
        }
        
        self.loadData(text: L10n.loading, promise: DataHandler.def.joinTeam(inviteId: self.inviteId!, teamType: self.mode!)).done({ apiResponse in
            self.dismiss(animated: true, completion: nil)
            FlowManager.selectAndOpenTeam(vc: self, teamId: apiResponse.team!.id)
        }).catch({ err in
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    
    
    
    
    
}
