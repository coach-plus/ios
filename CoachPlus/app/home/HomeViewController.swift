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
                self.view.backgroundColor = UIColor.coachPlusBlue

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
        self.loadData(text: "LOAD_DATA", promise: DataHandler.def.getMyTeams()).done({ apiResponse in
        }).catch({ err in
            print(err)
        })
    }
    
    func createTeam(name:String, isPublic:Bool) {
        
        self.loadData(text: "LOAD_DATA", promise: DataHandler.def.createTeam(name: name, isPublic: isPublic)).done({ apiResponse in
        }).catch({ err in
            print(err)
        })
        
    }
    
    func createInvitationLink(teamId:String, validDays:Int?) {
        self.loadData(text: "LOAD_DATA", promise: DataHandler.def.createInviteLink(teamId: teamId, validDays: validDays)).done({ apiResponse in
        }).catch({ err in
            print(err)
        })
    }

}
