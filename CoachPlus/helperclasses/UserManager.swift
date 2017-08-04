//
//  UserManager.swift
//  CoachPlus
//
//  Created by Maurice Breit on 04.08.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftyUserDefaults

class UserManager {
    static func storeUser(user:User) {
        let userString = user.toJson().rawString()!
        Defaults[.userJSON] = userString
    }
    
    static func getUser() -> User {
        let userString = Defaults[.userJSON]
        return userString.toObject(User.self)
    }
}

extension DefaultsKeys {
    static let userJSON = DefaultsKey<String>("user")
}
