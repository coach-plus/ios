//
//  ApiResponse.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 26.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import SwiftyJSON


class ApiResponse {
    
    var success: Bool
    var content: [JSON]?
    var message: String?
    
    init(success:Bool, message:String?, content:[JSON]?) {
        self.success = success
        self.message = message
        self.content = content
    }
    
    func isSuccess() -> Bool {
        return self.success
    }
    
    init(json:JSON) {
        
        self.success = json["success"].boolValue
        self.message = json["message"].stringValue
        
        if let content = json["content"].array {
            self.content = content
        } else {
            var cs = [JSON]()
            cs.append(json["content"])
            self.content = cs
        }
    }
    
    
    
}
