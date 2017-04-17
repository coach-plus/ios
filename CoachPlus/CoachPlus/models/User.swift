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
    }
    
    var id: String
    var firstname: String
    var lastname: String
    var email: String
    var image: String? = "https://pbs.twimg.com/profile_images/775833954314285057/FIxA8Vcq1.jpg"
    
    init(id:String, firstname:String, lastname:String, email:String) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
    }
    
    required init(json:JSON) {
        self.id = json[Fields.id.rawValue].stringValue
        self.firstname = json[Fields.firstname.rawValue].stringValue
        self.lastname = json[Fields.lastname.rawValue].stringValue
        self.email = json[Fields.email.rawValue].stringValue
    }
    
    func toJson() -> JSON {
        let json: JSON = [
            Fields.id.rawValue: self.id,
            Fields.firstname.rawValue: self.firstname,
            Fields.lastname.rawValue: self.lastname,
            Fields.email.rawValue: self.email]
        return json
    }
    
    var fullname:String {
        get {
            return "\(self.firstname) \(self.lastname)"
        }
    }
    
    func setImage(imageV:UIImageView) {
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: imageV.frame.size,
            radius: imageV.frame.size.height / 2
        )
        
        let url = URL(string: self.image!)!
        
        let placeholder = UIImage.fontAwesomeIcon(name: .userCircleO, textColor: UIColor.coachPlusBlue, size: imageV.frame.size)
        
        imageV.af_setImage(withURL: url, placeholderImage: placeholder, filter: filter)
    }

}
