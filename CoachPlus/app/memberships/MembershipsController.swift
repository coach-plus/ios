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
    
    var teamIdToBeSelected:String?
    
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
            if (self.teamIdToBeSelected != nil) {
                let membership = self.memberships.first(where: { membership in
                    return membership.team?.id == self.teamIdToBeSelected
                })
                if (membership != nil) {
                    self.selectMembership(membership: membership!)
                    self.teamIdToBeSelected = nil
                }
                
            }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let membership = self.memberships[indexPath.row]
        self.selectMembership(membership: membership)
    }
    
    func selectMembership(membership:Membership) {
        let team = membership.team
        
        let selectedMembership = MembershipManager.shared.selectedMembership
        
        if (selectedMembership?.team?.id != team?.id) {
            
            membership.user = Authentication.getUser()
            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToNewTeam") {
            if let targetNavVc = segue.destination as? CoachPlusNavigationViewController {
                if targetNavVc.childViewControllers.count > 0, let targetVc = targetNavVc.childViewControllers[0] as? CreateTeamViewController {
                    targetVc.membershipsController = self
                }
                
            }
        }
    }
    
    

}
