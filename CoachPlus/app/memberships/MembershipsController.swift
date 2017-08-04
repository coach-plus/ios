//
//  TeamsViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 29.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit

import SwiftIcons

class MembershipsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoBtn: UIButton!
    
    var memberships:[Membership] = MembershipManager.shared.getMemberships()
    
    var teamIdToBeSelected:String?
    
    private let refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "MembershipTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "MembershipCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)

        self.infoBtn.setIcon(icon: .googleMaterialDesign(.infoOutline), iconSize: 20, color: .white, backgroundColor: .clear, forState: .normal)
        
        self.loadTeams()
        
    }
    
    func refresh(_ sender: Any) {
        self.loadTeams()
    }
    
    @IBAction func infoBtnTapped(_ sender: Any) {
        
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
            self.refreshControl.endRefreshing()
        }, failHandler: { err in
            print(err)
            self.refreshControl.endRefreshing()
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
            teamController.membershipsController = self
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
