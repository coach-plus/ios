//
//  User.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 28.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import SwiftyJSON

class User:JSONable, BackJSONable {
    
    enum Fields:String {
        case firstname = "firstname"
        case id = "_id"
        case lastname = "lastname"
        case email = "email"
        case image = "image"
        case emailVerified = "emailVerified"
        case termsAccepted = "termsAccepted"
        case dataPrivacyAccepted = "dataPrivacyAccepted"
    }
    
    var id: String
    var firstname: String
    var lastname: String
    var email: String
    var image: String?
    var emailVerified: Bool?
    var termsAccepted: Bool?
    var dataPrivacyAccepted: Bool?
    
    init(id:String, firstname:String, lastname:String, email:String, image: String?, emailVerified: Bool?, termsAccepted: Bool?, dataPrivacyAccepted: Bool?) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.image = image
        self.emailVerified = emailVerified
        self.termsAccepted = termsAccepted
        self.dataPrivacyAccepted = dataPrivacyAccepted
    }
    
    required init(json:JSON) {
        self.id = json[Fields.id.rawValue].stringValue
        self.firstname = json[Fields.firstname.rawValue].stringValue
        self.lastname = json[Fields.lastname.rawValue].stringValue
        self.email = json[Fields.email.rawValue].stringValue
        self.image = json[Fields.image.rawValue].stringValue
        self.emailVerified = json[Fields.emailVerified.rawValue].bool
        self.termsAccepted = json[Fields.termsAccepted.rawValue].bool
        self.dataPrivacyAccepted = json[Fields.dataPrivacyAccepted.rawValue].bool
    }
    
    func toJson() -> JSON {
        let json: JSON = [
            Fields.id.rawValue: self.id,
            Fields.firstname.rawValue: self.firstname,
            Fields.lastname.rawValue: self.lastname,
            Fields.email.rawValue: self.email,
            Fields.image.rawValue: self.image,
            Fields.termsAccepted.rawValue: self.termsAccepted,
            Fields.dataPrivacyAccepted.rawValue: self.dataPrivacyAccepted]
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
        return String.init(format: "%@%@%@", Environment.backendURL.absoluteString, "uploads/", self.image!)
    }

}
