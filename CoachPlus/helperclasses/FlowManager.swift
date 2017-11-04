//
//  FlowManager.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 26.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import Hero

class FlowManager {
    
    static func homeVc() -> HomeDrawerController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! HomeDrawerController
        return vc
    }
    
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
    
    static func setLogin() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let vc = loginVc()
        delegate.window?.rootViewController = vc
        delegate.window?.makeKeyAndVisible()
    }
    
    static func goToLogin() {
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let vc = storyboard.instantiateInitialViewController()!
        
        UIApplication.shared.keyWindow?.currentViewController()?.present(vc, animated: true, completion: nil)
        
        //window.makeKeyAndVisible()
    }
    
    static func goToHome(sourceVc:UIViewController) {
        if (Authentication.loggedIn()) {
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            
            let vc = homeVc()
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
        let vc = homeVc()
        sourceVc.present(vc, animated: true, completion: nil)
    }
    
    static func presentMemberships(sourceVc:UIViewController) {
        let vc = membershipsVc()
        sourceVc.present(vc, animated: true, completion: nil)
    }
    
    static func getTeamViewController(sourceVc:UIViewController) {
        print(sourceVc.navigationController)
    }
    
}
