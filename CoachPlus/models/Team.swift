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
        case memberCount = "memberCount"
    }
    
    var id: String
    var isPublic: Bool
    var name: String
    var image: String?
    var memberCount: Int?
    
    init(id:String, isPublic:Bool, name:String, image:String, memberCount: Int?) {
        self.id = id
        self.isPublic = isPublic
        self.name = name
        self.image = image
        self.memberCount = memberCount
    }
    
    required init(json:JSON) {
        self.id = json[Fields.id.rawValue].stringValue
        self.isPublic = json[Fields.isPublic.rawValue].boolValue
        self.name = json[Fields.name.rawValue].stringValue
        self.image = json[Fields.image.rawValue].string
        self.memberCount = json[Fields.memberCount.rawValue].int
    }
    
    func toJson() -> JSON {
        let json: JSON = [
            Fields.id.rawValue: self.id,
            Fields.isPublic.rawValue: self.isPublic,
            Fields.name.rawValue: self.name,
            Fields.image.rawValue: self.image,
            Fields.memberCount.rawValue: self.memberCount]
        return json
    }
    
    func getTeamImageUrl() -> String {
        guard (self.image != nil) else {
            return ""
        }
        return String.init(format: "%@%@", "https://dev.coach.plus/uploads/", self.image!)
    }
    
    func getMemberCountString() -> String {
        if let count = self.memberCount {
            if (count == 1) {
                return L10n.oneMember
            }
            return L10n.multipleMembers(count)
        } else {
            return ""
        }
    }
    
}
