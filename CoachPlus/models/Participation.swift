//
//  Participation.swift
//  CoachPlus
//
//  Created by Maurice Breit on 17.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import SwiftyJSON

class Participation: JSONable, BackJSONable {
    
    enum Fields:String {
        case user = "user"
        case event = "event"
        case willAttend = "willAttend"
        case didAttend = "didAttend"
    }
    
    var user: String
    var event: String
    var willAttend: Bool?
    var didAttend: Bool?
    
    init(user:String, event:String, willAttend:Bool?, didAttend:Bool?) {
        self.user = user
        self.event = event
        self.willAttend = willAttend
        self.didAttend = didAttend
    }
    
    required init(json:JSON) {
        
        self.user = json[Fields.user.rawValue].stringValue
        self.event = json[Fields.event.rawValue].stringValue
        
        if let willAttend = json[Fields.willAttend.rawValue].bool {
            self.willAttend = willAttend
        }
        
        if let didAttend = json[Fields.didAttend.rawValue].bool {
            self.didAttend = didAttend
        }
    }
    
    func toJson() -> JSON {
        let json: JSON = [
            Fields.user.rawValue: self.user,
            Fields.event.rawValue: self.event,
            Fields.willAttend.rawValue: self.willAttend as Any,
            Fields.didAttend.rawValue: self.didAttend as Any]
        return json
    }
    
}
