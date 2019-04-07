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
import RxSwift

class UserManager {
    
    static let shared = UserManager()
    
    var userWasEdited: PublishSubject<User>
    
    init() {
        self.userWasEdited = PublishSubject<User>()
    }
    
    static func storeUser(user:User) {
        let userString = user.toJson().rawString()!
        Defaults[.userJSON] = userString
    }
    
    static func getUser() -> User {
        let userString = Defaults[.userJSON]
        return userString.toObject(User.self)
    }
    
    static func isSelf(userId: String?) -> Bool {
        return self.getUser().id == userId
    }
}

extension DefaultsKeys {
    static let userJSON = DefaultsKey<String>("user")
}
