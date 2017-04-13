//
//  TeamManager.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 31.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import SwiftyJSON

class MembershipManager {
    
    static let def = MembershipManager()
    
    var selectedMembership:Membership?
    
    var memberships:[Membership] = []
    
    func storeMemberships(memberships: [Membership]) {
        self.memberships = memberships
        Defaults[.membershipJSON] = memberships.toString()
    }
    
    func getMemberships() -> [Membership] {
        self.memberships = Defaults[.membershipJSON].toArray(Membership.self)
        return self.memberships
    }
}


extension DefaultsKeys {
    static let membershipJSON = DefaultsKey<String>("teams")
}
