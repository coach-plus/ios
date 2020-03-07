//
//  FlowManager.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 26.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import Hero
import MMDrawerController
import PromiseKit
import MBProgressHUD

class FlowManager {
    
    static func loginVc() -> LoginViewController {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! LoginViewController
        return vc
    }
    
    static func profileVc() -> UserViewController {
        let vc = UIStoryboard(name: "User", bundle: nil).instantiateInitialViewController() as! UserViewController
        return vc
    }
    
    static func membershipsVc() -> UIViewController {
        let vc = UIStoryboard(name: "Memberships", bundle: nil).instantiateInitialViewController()!
        return vc
    }
    
    static func userSettingsVc() -> UIViewController {
        let vc = UIStoryboard(name: "UserSettings", bundle: nil).instantiateInitialViewController()!
        return vc
    }
    
    static func createEditTeamVc() -> CoachPlusNavigationViewController {
        let vc = UIStoryboard(name: "NewTeam", bundle: nil).instantiateInitialViewController() as! CoachPlusNavigationViewController
        return vc
    }
    
    static func createEditEventVc(mode: CreateEventViewController.Mode, membership: Membership?, event: Event?, delegate: CreateEventViewControllerDelegate?) -> CoachPlusNavigationViewController {
        let vc = UIStoryboard(name: "CreateEvent", bundle: nil).instantiateInitialViewController() as! CoachPlusNavigationViewController
        let createEventVc = vc.children[0] as! CreateEventViewController
        
        createEventVc.mode = mode
        
        if (membership != nil) {
            createEventVc.membership = membership
        }
        if (event != nil) {
            createEventVc.event = event
        }
        if (delegate != nil) {
            createEventVc.delegate = delegate
        }
        
        return vc
    }
    
    static func setLogin() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let vc = loginVc()
        delegate.window?.rootViewController = vc
        delegate.window?.makeKeyAndVisible()
    }
    
    static func homeVc() -> CoachPlusNavigationViewController {
        let teamStoryboard = UIStoryboard(name: "Team", bundle: nil)
        let teamNavVc = teamStoryboard.instantiateInitialViewController() as! CoachPlusNavigationViewController
        NotificationManager.shared.setCurrentVc(currentVc: teamNavVc.children[0] as! TeamViewController)
        NotificationManager.shared.setTeamVc(teamVc: teamNavVc.children[0] as! TeamViewController)
        return teamNavVc
    }
    
    static func drawerVc() -> MMDrawerController {
        let membershipsStoryboard = UIStoryboard(name: "Memberships", bundle: nil)
        
        var centerViewController = FlowManager.homeVc()
        var leftViewController = membershipsStoryboard.instantiateInitialViewController()!
        
        let centerContainer = MMDrawerController(center: centerViewController, leftDrawerViewController: leftViewController, rightDrawerViewController: nil)
        
        centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningNavigationBar
        centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.all
        
        centerContainer!.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionMode.none
        
        self.openAndCloseDrawer(vc: centerContainer!)
        
        return centerContainer!
    }
    
    static func setHome() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let drawerVc = FlowManager.drawerVc()
        delegate.window?.rootViewController = drawerVc
        delegate.window?.makeKeyAndVisible()
    }
    
    static func goToLogin(completion: (() -> Void)? = nil) {
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let vc = storyboard.instantiateInitialViewController()!
        
        UIApplication.shared.keyWindow?.rootViewController?.presentModally(vc, animated: true, completion: completion)
    }
    
    static func goToHome(sourceVc:UIViewController) {
        if (Authentication.loggedIn()) {
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            
            let vc = drawerVc()
            let window = delegate.window!
            
            UIView.transition(from: sourceVc.view, to: vc.view, duration: 0.6, options: [.transitionCrossDissolve], completion: {
                _ in
                window.rootViewController = vc
                window.makeKeyAndVisible()
            })
            
            
        } else {
            goToLogin()
        }
    }
    
    static func presentHome(sourceVc:UIViewController) {
        let vc = drawerVc()
        sourceVc.presentModally(vc, animated: true, completion: nil)
    }
    
    static func presentMemberships(sourceVc:UIViewController) {
        let vc = membershipsVc()
        sourceVc.presentModally(vc, animated: true, completion: nil)
    }
    
    static func getTeamViewController(sourceVc:UIViewController) {
        print(sourceVc.navigationController)
    }
    
    static func getDrawerController() -> MMDrawerController? {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.window?.rootViewController as? MMDrawerController
    }
    
    static func openTeamSelection(vc: UIViewController) {
        let membershipsVc = self.membershipsVc()
        vc.presentModally(membershipsVc, animated: true, completion: nil)
    }
    
    static func openDrawer() {
        let controller = getDrawerController()
        
        if let vc = controller {
            if (vc.openSide == MMDrawerSide.left) {
                vc.closeDrawer(animated: true, completion: nil)
            } else {
                vc.open(MMDrawerSide.left, animated: true, completion: nil)
            }
        }
    }

    static func openAndCloseDrawer(vc: MMDrawerController) {
        vc.open(MMDrawerSide.left, animated: false, completion: { _ in
            vc.closeDrawer(animated: false, completion: nil)
        })
    }
    
    static func openVcInCenter(vc: UIViewController) {
        FlowManager.hideHUD()
        FlowManager.getDrawerController()?.centerViewController = vc
        getDrawerController()?.closeDrawer(animated: true, completion: nil)
        
    }
    
    static func selectAndOpenTeam(vc: UIViewController, teamId: String?) {
        let rootVc = self.getDrawerController()
        
        if (rootVc != nil) {
            MBProgressHUD.createHUD(view: rootVc!.view, msg: L10n.loading)
        }
        
        
        var promise: Promise<Membership?>?
        
        if (teamId != nil) {
            promise = MembershipManager.shared.getMembershipForTeam(teamId: teamId!)
        } else {
            promise = MembershipManager.shared.getRandomMembership()
        }
        
        promise?.done({membership in
            let centerVc = rootVc?.centerViewController as! CoachPlusNavigationViewController
            let teamVc = centerVc.children[0] as! TeamViewController
            rootVc?.closeDrawer(animated: true, completion: nil)
            self.hideHUD()
            MembershipManager.shared.setSelectedMembership(membership: membership)
            //teamVc.selectedMembership(membership: membership)
            vc.dismiss(animated: true, completion: nil)
        }).catch({ err in
            print(err)
            self.hideHUD()
        })
        
    }
    
    static func hideHUD() {
        let rootVc = self.getDrawerController()
        if (rootVc != nil) {
            MBProgressHUD.hide(for: rootVc!.view, animated: true)
        }
        
    }
}
