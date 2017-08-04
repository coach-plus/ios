//
//  Event.swift
//  CoachPlus
//
//  Created by Maurice Breit on 13.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import SwiftyJSON

class Event:JSONable, BackJSONable {
    
    enum Fields:String {
        case name = "name"
        case id = "_id"
        case description = "description"
        case start = "start"
        case end = "end"
        case teamId = "team"
    }
    
    var id: String
    var name: String
    var description: String
    var start: Date
    var end: Date
    var teamId: String
    var participations: [Participation]?
    
    init(id:String, name:String, description:String, start:Date, end:Date, teamId:String) {
        self.id = id
        self.name = name
        self.description = description
        self.start = start
        self.end = end
        self.teamId = teamId
    }
    
    required init(json:JSON) {
        self.id = json[Fields.id.rawValue].stringValue
        self.name = json[Fields.name.rawValue].stringValue
        self.description = json[Fields.description.rawValue].stringValue
        self.start = json[Fields.start.rawValue].stringValue.toDate()
        self.end = json[Fields.end.rawValue].stringValue.toDate()
        self.teamId = json[Fields.teamId.rawValue].stringValue
    }
    
    func toJson() -> JSON {
        let json: JSON = [
            Fields.id.rawValue: self.id,
            Fields.name.rawValue: self.name,
            Fields.description.rawValue: self.name,
            Fields.start.rawValue: self.start.toString(),
            Fields.end.rawValue: self.end.toString(),
            Fields.teamId.rawValue: self.teamId]
        return json
    }
    
    func isInPast() -> Bool {
        return self.end.timeIntervalSinceNow.sign == .minus
    }
    
    func fromToStringWithDate() -> String {
        return "\(self.start.string(dateStyle: .short, timeStyle: .short, in: nil)) - \(self.end.string(dateStyle: .none, timeStyle: .short, in: nil))"
    }
    
    func fromToString() -> String {
        return "\(self.start.string(dateStyle: .none, timeStyle: .short, in: nil)) - \(self.end.string(dateStyle: .none, timeStyle: .short, in: nil))"
    }
    
    func dateString() -> String {
        return self.start.string(dateStyle: .short, timeStyle: .none, in: nil)
    }
    
    
}
