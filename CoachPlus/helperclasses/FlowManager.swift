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
    
    static func setLogin() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let vc = loginVc()
        delegate.window?.rootViewController = vc
        delegate.window?.makeKeyAndVisible()
    }
    
    static func homeVc() -> CoachPlusNavigationViewController {
        let teamStoryboard = UIStoryboard(name: "Team", bundle: nil)
        return teamStoryboard.instantiateInitialViewController() as! CoachPlusNavigationViewController
    }
    
    static func drawerVc() -> MMDrawerController {
        let membershipsStoryboard = UIStoryboard(name: "Memberships", bundle: nil)
        
        var centerViewController = FlowManager.homeVc()
        var leftViewController = membershipsStoryboard.instantiateInitialViewController()!
        
        let centerContainer = MMDrawerController(center: centerViewController, leftDrawerViewController: leftViewController, rightDrawerViewController: nil)
        
        centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningNavigationBar
        centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.all
        
        centerContainer?.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionMode.none
        
        return centerContainer!
    }
    
    static func setHome() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = FlowManager.drawerVc()
        delegate.window?.makeKeyAndVisible()
    }
    
    static func goToLogin() {
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let vc = storyboard.instantiateInitialViewController()!
        
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
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
        sourceVc.present(vc, animated: true, completion: nil)
    }
    
    static func presentMemberships(sourceVc:UIViewController) {
        let vc = membershipsVc()
        sourceVc.present(vc, animated: true, completion: nil)
    }
    
    static func getTeamViewController(sourceVc:UIViewController) {
        print(sourceVc.navigationController)
    }
    
    static func getDrawerController() -> MMDrawerController {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.window?.rootViewController as! MMDrawerController
    }
    
    static func openTeamSelection(vc: UIViewController) {
        let membershipsVc = self.membershipsVc()
        vc.present(membershipsVc, animated: true, completion: nil)
    }
    
    static func openDrawer() {
        let controller = getDrawerController()
        
        if (controller.openSide == MMDrawerSide.left) {
            controller.closeDrawer(animated: true, completion: nil)
        } else {
            controller.open(MMDrawerSide.left, animated: true, completion: nil)
        }
    }
    
    static func openVcInCenter(vc: UIViewController) {
        FlowManager.hideHUD()
        FlowManager.getDrawerController().centerViewController = vc
        getDrawerController().closeDrawer(animated: true, completion: nil)
        
    }
    
    static func selectAndOpenTeam(vc: UIViewController, teamId: String?) {
        let rootVc = self.getDrawerController()
        
        MBProgressHUD.createHUD(view: rootVc.view, msg: "LOAD_TEAM".localize())
        
        let navVc = rootVc.leftDrawerViewController as! UINavigationController
        let membershipsController = navVc.children[0] as! MembershipsController
        if (teamId != nil) {
            membershipsController.teamIdToBeSelected = teamId
        } else {
            membershipsController.teamIdToBeSelected = "any"
        }
        
        membershipsController.loadTeams()
    }
    
    static func hideHUD() {
        let rootVc = self.getDrawerController()
        MBProgressHUD.hide(for: rootVc.view, animated: true)
    }
}
