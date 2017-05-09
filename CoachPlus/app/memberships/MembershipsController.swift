//
//  TeamsViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 29.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit

class MembershipsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var memberships:[Membership] = MembershipManager.def.getMemberships()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "MembershipTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "MembershipCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadTeams()
    }
    
    @IBAction func refreshBtnTapped(_ sender: Any) {
        self.loadTeams()
    }
    
    
    func loadTeams() {
        
        _ = DataHandler.def.getMyMemberships(successHandler: { memberships in
            self.memberships = memberships
            MembershipManager.def.storeMemberships(memberships: self.memberships)
            self.tableView.reloadData()
        }, failHandler: { err in
            print(err)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memberships.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let membership = self.memberships[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MembershipCell", for: indexPath) as! MembershipTableViewCell
        cell.setup(membership: membership)
        
        return cell
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToTeam") {
            let navVc = segue.destination as! UINavigationController
            let target = navVc.viewControllers[0] as! TeamViewController
            let team = self.memberships[self.tableView.indexPathForSelectedRow!.row].team
            target.team = team
        }
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToTeam", sender: nil)
    }
 */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let team = self.memberships[indexPath.row].team

        let teamStoryboard = UIStoryboard(name: "Team", bundle: nil)
        
        let navController = teamStoryboard.instantiateInitialViewController() as! CoachPlusNavigationViewController
        let teamController = navController.viewControllers[0] as! TeamViewController

        teamController.team = team
        
        self.slideMenuController()?.changeMainViewController(navController, close: true)
        
    }
    
    

}
