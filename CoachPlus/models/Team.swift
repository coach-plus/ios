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
        case image = "image"
    }
    
    var id: String
    var isPublic: Bool
    var name: String
    var image: String?
    
    init(id:String, isPublic:Bool, name:String, image:String) {
        self.id = id
        self.isPublic = isPublic
        self.name = name
        self.image = image
    }
    
    required init(json:JSON) {
        self.id = json[Fields.id.rawValue].stringValue
        self.isPublic = json[Fields.isPublic.rawValue].boolValue
        self.name = json[Fields.name.rawValue].stringValue
        self.image = json[Fields.image.rawValue].string
    }
    
    func toJson() -> JSON {
        let json: JSON = [
            Fields.id.rawValue: self.id,
            Fields.isPublic.rawValue: self.isPublic,
            Fields.name.rawValue: self.name,
            Fields.image.rawValue: self.image]
        return json
    }
    
    func getTeamImageUrl() -> String {
        if let img = self.image {
            return String.init(format: "%@%@", "https://dev.coach.plus/uploads/", self.image!)
        }
        return ""
        
    }
    
}
