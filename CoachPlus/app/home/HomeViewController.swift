//
//  HomeViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 26.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //self.createTeam(name: "TestTeam1", isPublic: true)
        
        //self.createInvitationLink(teamId: "58da450fe420a5469a814a3a", validDays: 7)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        Authentication.logout()
    }

    
    func getMyTeams() {
        _ = DataHandler.def.getMyTeams(successHandler: { teams in
            
        }, failHandler: { err in
            print(err)
        })
    }
    
    func createTeam(name:String, isPublic:Bool) {
        
        _ = DataHandler.def.createTeam(name: name, isPublic: isPublic, successHandler: { apiResponse in
            print("success")
        }, failHandler: { err in
            print(err)
        })
        
    }
    
    func createInvitationLink(teamId:String, validDays:Int?) {
        _ = DataHandler.def.createInviteLink(teamId: teamId, validDays: validDays, failHandler: { err in
            print(err)
        })
    }

}
