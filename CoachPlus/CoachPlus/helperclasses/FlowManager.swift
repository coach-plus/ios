//
//  FlowManager.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 26.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation

class FlowManager {
    
    static func homeVc() -> HomeViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        
        let vc = storyboard.instantiateInitialViewController() as! HomeViewController
        
        return vc
    }
    
    static func goToLogin() {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let vc = storyboard.instantiateInitialViewController()!
        
        let window = delegate.window!
        window.rootViewController = vc
        window.makeKeyAndVisible()
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
