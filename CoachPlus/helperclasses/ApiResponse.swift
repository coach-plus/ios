//
//  ApiResponse.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 26.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import SwiftyJSON


class ApiResponse:JSONable {
    
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
    
    required init(json:JSON) {
        
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
    
    func toObject<T:JSONable>(_ t:T.Type, property:String?) -> T {
        if (property == nil) {
            return T(json:self.content![0])!
        } else {
            return T(json:(self.content![0])[property!])!
        }
    }
    
    func toArray<T:JSONable>(_ t:T.Type, property:String?) -> [T] {
        var array = [T]()
        
        let json:[JSON]
        
        if (property == nil) {
            json = self.content!
        } else {
            json = ((self.content?[0])?[property!].array)!
        }
        
        for item in json {
            let object = T(json:item)
            array.append(object!)
        }
        
        return array
        
    }
    
    
    
}
