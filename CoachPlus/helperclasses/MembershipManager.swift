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
    
    static let shared = MembershipManager()
    
    var selectedMembership:Membership?
    
    var memberships:[Membership] = []
    
    func selectMembership(membership:Membership) {
        Defaults[.selectedMembershipId] = membership.id
    }
    
    func getPreviouslySelectedMembership() -> Membership? {
        let membershipId = Defaults[.selectedMembershipId]
        guard membershipId != "" else {
            return nil
        }
        
        let memberships = self.getMemberships()
        
        if (memberships.count == 0) {
            return nil
        }
        
        if (memberships.count == 1) {
            selectedMembership = memberships[0]
            return memberships[0]
        }
        
        let matchingMemberships = memberships.filter({ membership in
            return (membership.id == membershipId)
        })
        
        if (matchingMemberships.count > 0) {
            selectedMembership = matchingMemberships[0]
            return matchingMemberships[0]
        }
        
        selectedMembership = nil
        return nil
        
    }
    
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
    static let selectedMembershipId = DefaultsKey<String>("selectedMembershipId")
}
