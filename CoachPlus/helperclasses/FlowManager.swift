//
//  FlowManager.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 26.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation

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
    
    static func goToHome() {
        if (Authentication.loggedIn()) {
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            
            let vc = homeVc()
            
            let window = delegate.window!
            window.rootViewController = vc
            window.makeKeyAndVisible()
        } else {
            goToLogin()
        }
    }
    
    static func presentHome(sourceVc:UIViewController) {
        let vc = homeVc()
        sourceVc.present(vc, animated: true, completion: nil)
    }
    
}
