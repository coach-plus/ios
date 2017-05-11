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
    
    var memberships:[Membership] = MembershipManager.shared.getMemberships()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "MembershipTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "MembershipCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70

        self.loadTeams()
        
    }
    
    @IBAction func refreshBtnTapped(_ sender: Any) {
        self.loadTeams()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        Authentication.logout()
    }
    
    
    func loadTeams() {
        
        _ = DataHandler.def.getMyMemberships(successHandler: { memberships in
            self.memberships = memberships
            MembershipManager.shared.storeMemberships(memberships: self.memberships)
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
        let membership = self.memberships[indexPath.row]
        let team = membership.team
        
        let selectedMembership = MembershipManager.shared.selectedMembership
        
        if (selectedMembership?.team?.id != team?.id) {
            
            MembershipManager.shared.selectedMembership = membership
            let teamStoryboard = UIStoryboard(name: "Team", bundle: nil)
            
            let navController = teamStoryboard.instantiateInitialViewController() as! CoachPlusNavigationViewController
            let teamController = navController.viewControllers[0] as! TeamViewController
            
            teamController.membership = membership
            
            self.slideMenuController()?.changeMainViewController(navController, close: true)
        } else {
            let controller = UIApplication.shared.keyWindow?.rootViewController
            controller?.closeLeft()
        }

        
    }
    
    

}
