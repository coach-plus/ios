//
//  News.swift
//  CoachPlus
//
//  Created by Maurice Breit on 04.08.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import Foundation
import SwiftyJSON

class News:JSONable, BackJSONable {
    
    enum Fields:String {
        case id = "_id"
        case title = "title"
        case text = "text"
        case author = "author"
        case eventId = "event"
        case created = "created"
    }
    
    var id: String
    var title: String
    var text: String
    var author: User?
    var eventId: String
    var created: Date
    
    init(id:String, title:String, text:String, author:User, eventId:String, created:Date) {
        self.id = id
        self.title = title
        self.text = text
        self.author = author
        self.eventId = eventId
        self.created = created
    }
    
    required init(json:JSON) {
        self.id = json[Fields.id.rawValue].stringValue
        self.title = json[Fields.title.rawValue].stringValue
        self.text = json[Fields.text.rawValue].stringValue
        
        let author = json[Fields.author.rawValue]
        if (author.type != .string) {
            self.author = User(json: author)
        }
        
        self.eventId = json[Fields.eventId.rawValue].stringValue
        self.created = json[Fields.created.rawValue].stringValue.toDate()
    }
    
    func toJson() -> JSON {
        let json: JSON = [
            Fields.id.rawValue: self.id,
            Fields.title.rawValue: self.title,
            Fields.text.rawValue: self.text,
            Fields.author.rawValue: self.author?.toJson(),
            Fields.eventId.rawValue: self.eventId,
            Fields.created.rawValue: self.created.toString()]
        return json
    }
    
    func dateTimeString() -> String {
        return self.created.simpleFormatted()
    }
}
