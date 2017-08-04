//
//  User.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 28.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import SwiftyJSON
import AlamofireImage

class User:JSONable, BackJSONable {
    
    enum Fields:String {
        case firstname = "firstname"
        case id = "_id"
        case lastname = "lastname"
        case email = "email"
        case image = "image"
    }
    
    var id: String
    var firstname: String
    var lastname: String
    var email: String
    var image: String?
    
    init(id:String, firstname:String, lastname:String, email:String, image: String?) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.image = image
    }
    
    required init(json:JSON) {
        self.id = json[Fields.id.rawValue].stringValue
        self.firstname = json[Fields.firstname.rawValue].stringValue
        self.lastname = json[Fields.lastname.rawValue].stringValue
        self.email = json[Fields.email.rawValue].stringValue
        self.image = json[Fields.image.rawValue].stringValue
    }
    
    func toJson() -> JSON {
        let json: JSON = [
            Fields.id.rawValue: self.id,
            Fields.firstname.rawValue: self.firstname,
            Fields.lastname.rawValue: self.lastname,
            Fields.email.rawValue: self.email,
            Fields.image.rawValue: self.image]
        return json
    }
    
    var fullname:String {
        get {
            return "\(self.firstname) \(self.lastname)"
        }
    }
    
    func getUserImageUrl() -> String {
        guard (self.image != nil) else {
            return ""
        }
        return String.init(format: "%@%@", "https://dev.coach.plus/uploads/", self.image!)
    }

}
