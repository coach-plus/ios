//
//  Membership.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 28.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import SwiftyJSON


class Membership:JSONable, BackJSONable {
    
    enum Fields:String {
        case role = "role"
        case id = "_id"
        case user = "user"
        case team = "team"
        case joined = "joined"
    }
    
    enum Role:String {
        case coach = "coach"
        case user = "user"
    }
    
    var id: String
    var role: String
    var user: User?
    var team: Team?
    var joined: Bool?
    
    init(id:String, role:String, user:User?, team:Team?, joined: Bool?) {
        self.id = id
        self.role = role
        self.user = user
        self.team = team
        self.joined = joined
    }
    
    required init(json:JSON) {
        self.id = json[Fields.id.rawValue].stringValue
        self.role = json[Fields.role.rawValue].stringValue
        self.joined = json[Fields.joined.rawValue].bool
        
        let user = json[Fields.user.rawValue]
        if (user.type != .string) {
            self.user = User(json: user)
        }
        
        let team = json[Fields.team.rawValue]
        if (team.type != .string) {
            self.team = Team(json: team)
        }
    }
    
    func isCoach() -> Bool {
        return self.role == "coach"
    }
    
    func toJson() -> JSON {
        let json: JSON = [
            Fields.id.rawValue: self.id,
            Fields.role.rawValue: self.role,
            Fields.user.rawValue: self.user?.toJson(),
            Fields.team.rawValue: self.team?.toJson(),
            Fields.joined.rawValue: self.joined]
        return json
    }
}
