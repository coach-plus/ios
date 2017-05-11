//
//  CoachPlusViewController.swift
//  CoachPlus
//
//  Created by Maurice Breit on 16.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit

class CoachPlusViewController: UIViewController {
    
    var membership:Membership?

    override func viewDidLoad() {
        self.setCoachPlusLogo()
        
        if (self.membership == nil) {
            self.membership = MembershipManager.shared.getPreviouslySelectedMembership()
        }
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupNavBarDelegate() {
        if let navbar = self.navigationController?.navigationBar as? CoachPlusNavigationBar {
            navbar.coachPlusNavigationBarDelegate = self as? CoachPlusNavigationBarDelegate
        }
    }
    
    func pushToEventDetail(event:Event) {
        let targetVc = UIStoryboard(name: "EventDetail", bundle: nil).instantiateInitialViewController() as! EventDetailViewController
        targetVc.event = event
        self.navigationController?.pushViewController(targetVc, animated: true)
    }
    
    func setLeftBarButton(type:CoachPlusNavigationBar.BarButtonType) {
        if let navbar = self.navigationController?.navigationBar as? CoachPlusNavigationBar {
            navbar.setLeftBarButtonType(type: type)
        }
    }
    
    func setRightBarButton(type:CoachPlusNavigationBar.BarButtonType) {
        if let navbar = self.navigationController?.navigationBar as? CoachPlusNavigationBar {
            navbar.setRightBarButtonType(type: type)
        }
    }
    
}
