//
//  TeamsViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 29.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit

import SwiftIcons
import DZNEmptyDataSet

class MembershipsController: ViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoBtn: UIButton!
    
    @IBOutlet weak var topbarView: UIView!
    @IBOutlet weak var bottombarView: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var memberships:[Membership] = MembershipManager.shared.getMemberships()
    
    var teamIdToBeSelected:String?
    
    private let refreshControl = UIRefreshControl()

    func setSeparator() {
        self.setSeparator(tableView: self.tableView, toCheck: self.memberships)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.coachPlusBlue
        self.bottombarView.backgroundColor = UIColor.coachPlusBlue
        self.topbarView.backgroundColor = UIColor.coachPlusBlue
        
        self.setSeparator()
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        let cellNib = UINib(nibName: "MembershipTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "MembershipCell")
        
        tableView.rowHeight = UITableView.automaticDimension
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
    
    @objc func refresh(_ sender: Any) {
        self.loadTeams()
    }
    
    @IBAction func infoBtnTapped(_ sender: Any) {
        self.openWebpage(urlString: CoachPlus.aboutUrl)
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        Authentication.logout()
    }
    
    
    func loadTeams() {
        DataHandler.def.getMyMemberships().done({ memberships in
            self.memberships = memberships
            self.setSeparator()
            self.tableView.reloadData()
            if (self.teamIdToBeSelected != nil) {
                var membership: Membership?
                membership = self.memberships.first(where: { membership in
                    return membership.team?.id == self.teamIdToBeSelected
                })
                if (membership == nil && self.memberships.count > 0) {
                    membership = self.memberships[0]
                }
                if (membership != nil) {
                    self.selectMembership(membership: membership!)
                } else {
                    self.goToHomeWithoutMembership()
                }
                self.teamIdToBeSelected = nil
            }
            self.refreshControl.endRefreshing()
        }).catch({ err in
            print(err)
            self.setSeparator()
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
            
            MembershipManager.shared.selectMembership(membership: membership)
            
            let teamStoryboard = UIStoryboard(name: "Team", bundle: nil)
            
            let navController = teamStoryboard.instantiateInitialViewController() as! CoachPlusNavigationViewController
            let teamController = navController.viewControllers[0] as! TeamViewController
            teamController.membershipsController = self
            teamController.membership = membership
            
            FlowManager.openVcInCenter(vc: navController)
            
        } else {
            self.dismiss(animated: true, completion: nil)
            FlowManager.getDrawerController().closeDrawer(animated: true, completion: nil)
        }

    }
    
    func goToHomeWithoutMembership() {
        
        MembershipManager.shared.selectedMembership = nil
        
        let teamStoryboard = UIStoryboard(name: "Team", bundle: nil)
        
        let navController = teamStoryboard.instantiateInitialViewController() as! CoachPlusNavigationViewController
        let teamController = navController.viewControllers[0] as! TeamViewController
        teamController.membershipsController = self
        teamController.membership = nil
        
        FlowManager.openVcInCenter(vc: navController)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToNewTeam") {
            if let targetNavVc = segue.destination as? CoachPlusNavigationViewController {
                if targetNavVc.children.count > 0, let targetVc = targetNavVc.children[0] as? CreateTeamViewController {
                    targetVc.membershipsController = self
                }
                
            }
        }
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(icon: .fontAwesomeSolid(.lifeRing), size: CGSize.init(width: 50, height: 50), textColor: .coachPlusBlue, backgroundColor: .clear)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)] as Dictionary!
        
        let string = "EMPTY_TEAMS".localize()
        
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        
        return attributedString
    }
    
    

}
