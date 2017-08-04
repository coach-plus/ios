//
//  ParticipationItem.swift
//  CoachPlus
//
//  Created by Maurice Breit on 04.08.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import SwiftyJSON

class ParticipationItem: JSONable, BackJSONable {
    
    enum Fields:String {
        case user = "user"
        case participation = "participation"
    }
    
    var user: User?
    var participation: Participation?
    
    init(user:User, participation:Participation) {
        self.user = user
        self.participation = participation
    }
    
    required init(json:JSON) {
        
        let user = json[Fields.user.rawValue]
        if (user.type != .string) {
            self.user = User(json: user)
        }
        
        let participation = json[Fields.participation.rawValue]
        if (participation.type != .string) {
            self.participation = Participation(json: participation)
        }
    }
    
    func toJson() -> JSON {
        let json: JSON = [
            Fields.user.rawValue: self.user?.toJson(),
            Fields.participation.rawValue: self.participation?.toJson()]
        return json
    }
    
}
