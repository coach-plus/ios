//
//  Team.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 28.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import SwiftyJSON

class Team:JSONable, BackJSONable {
    
    enum Fields:String {
        case name = "name"
        case id = "_id"
        case isPublic = "isPublic"
    }
    
    var id: String
    var isPublic: Bool
    var name: String
    
    init(id:String, isPublic:Bool, name:String) {
        self.id = id
        self.isPublic = isPublic
        self.name = name
    }
    
    required init(json:JSON) {
        self.id = json[Fields.id.rawValue].stringValue
        self.isPublic = json[Fields.isPublic.rawValue].boolValue
        self.name = json[Fields.name.rawValue].stringValue
    }
    
    func toJson() -> JSON {
        let json: JSON = [
            Fields.id.rawValue: self.id,
            Fields.isPublic.rawValue: self.isPublic,
            Fields.name.rawValue: self.name]
        return json
    }
    
}
