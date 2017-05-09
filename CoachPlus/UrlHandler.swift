//
//  UrlHandler.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 24.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit

class UrlHandler {
    
    static func handleUrlComponents(components: URLComponents) -> Bool {
        
        var pathArray = components.path.components(separatedBy: "/")
        
        pathArray.remove(at: 0)
        
        if (pathArray[0] != "app") {
            return false
        }
        
        if (pathArray[1] == "verification") {
            pathArray.remove(at: 0)
            pathArray.remove(at: 0)
            return UrlHandler.handleVerificationUrl(pathArray)
        }
        
        if (pathArray[1] == "teams") {
            
            let mode = pathArray[2]
            if (mode == "private" || mode == "public") {
                
                if (pathArray[3] == "join") {
                    
                    let inviteId = pathArray[4]
                    
                    let storyboard = UIStoryboard(name: "JoinTeam", bundle: nil)
                    let navVc = storyboard.instantiateInitialViewController() as! CoachPlusNavigationViewController
                    let joinVc = navVc.childViewControllers[0] as! JoinTeamViewController
                    
                    if (mode == "private") {
                        joinVc.mode = .privateTeam
                    } else {
                        joinVc.mode = .publicTeam
                    }
                    
                    joinVc.inviteId = inviteId
                    
                    let rootVc = UIApplication.shared.keyWindow?.rootViewController!
                    
                    print(rootVc)
                    
                    let vcs = rootVc!.childViewControllers
                    
                    for vc in vcs {
                        print(vc)
                    }
                    
                    print("vcs")
                    print(rootVc?.isBeingPresented)
                    
                    rootVc?.present(navVc, animated: true, completion: nil)
                    
                    
                    /*
                    
                    if let homeVc = rootVc as? HomeDrawerController {
                        
                        if let navVc = homeVc.mainViewController as? CoachPlusNavigationViewController {
                            let vc = navVc.childViewControllers[0]
                            vc.present(joinVc, animated: true, completion: nil)
                        } else {
                            homeVc.mainViewController?.present(joinVc, animated: true, completion: nil)
                        }
                        
                        
                    } else {
                        rootVc!.present(joinVc, animated: true, completion: nil)
                    }
                    */
                    
                    
                }
                
            }
            
        }
        
        return false
        
    }
    
    
    static func handleVerificationUrl(_ pathArray:Array<Any>) -> Bool {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        if (pathArray.count > 0) {
            let token = pathArray[0] as! String
            
            let storyboard = UIStoryboard(name: "Verification", bundle: nil)
            let verificationVC = storyboard.instantiateInitialViewController() as! VerificationViewController
            
            verificationVC.token = token
            
            let rootVc = UIApplication.shared.keyWindow?.currentViewController()
            
            print(rootVc)
            
            rootVc!.present(verificationVC, animated: true, completion: nil)
            
            //rootVc.present(navVc, animated: true, completion: nil)
            
            
            return true
        }
        
        return false
        
    }
}
