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
        
        return false
        
    }
    
    
    static func handleVerificationUrl(_ pathArray:Array<Any>) -> Bool {
        
        if (pathArray.count > 0) {
            let token = pathArray[0] as! String
            
            let storyboard = UIStoryboard(name: "Verification", bundle: nil)
            let verificationVC = storyboard.instantiateInitialViewController() as! VerificationViewController
            
            verificationVC.token = token
            
            UIApplication.shared.keyWindow?.rootViewController = verificationVC
            
            //rootVc.present(navVc, animated: true, completion: nil)
            
            
            return true
        }
        
        return false
        
    }
}
