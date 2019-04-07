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
import RxSwift
import PromiseKit

class MembershipManager {
    
    enum MembershipError: Error {
        case notFound
    }
    
    static let shared = MembershipManager()
    
    var selectedMembership:Membership?
    var selectedMembershipSubject: BehaviorSubject<Membership?>
    
    var memberships:[Membership] = []
    var membershipsSubject: BehaviorSubject<[Membership]>
    
    init() {
        self.membershipsSubject = BehaviorSubject<[Membership]>(value: [])
        self.selectedMembershipSubject = BehaviorSubject<Membership?>(value: nil)
        
        self.setMemberships(memberships: self.getStoredMemberships())
        self.setSelectedMembership(membership: self.getPreviouslySelectedMembership())
    }
    
    func setMemberships(memberships: [Membership]) {
        self.memberships = memberships
        self.storeMemberships(memberships: memberships)
        self.membershipsSubject.onNext(self.memberships)
        
        if (self.selectedMembership != nil) {
            let membershipIndex = self.memberships.firstIndex(where: { membership in
                return membership.id == self.selectedMembership!.id
            })
            if let i = membershipIndex, i >= 0, i <= self.memberships.count {
                self.setSelectedMembership(membership: self.memberships[i])
            }
        }
        
    }
    
    func setSelectedMembership(membership: Membership?) {
        self.selectedMembership = membership
        self.storeSelectedMembership(membership: membership)
        self.selectedMembershipSubject.onNext(self.selectedMembership)
    }
    
    func getRandomMembership() -> Promise<Membership?> {
        return Promise<Membership?> { p in
            self.loadMemberships().done({ memberships in
                self.storeMemberships(memberships: memberships)
                if (memberships.count > 0) {
                    p.fulfill(self.memberships[0])
                    return
                } else {
                    p.fulfill(nil)
                    return
                }
            }).catch({ err in
                p.fulfill(nil)
                return
            })
        }
    }
    
    func getMembershipForTeam(teamId: String) -> Promise<Membership?> {
        return Promise<Membership?> { p in
            
            let localMembership = self.getMembershipFromLocalMemberships(teamId: teamId)
            if (localMembership != nil) {
                p.fulfill(localMembership!)
                return
            } else {
                self.loadMemberships().done({ memberships in
                    let membership = self.getMembershipFromLocalMemberships(teamId: teamId)
                    if (membership != nil) {
                        p.fulfill(membership!)
                        return
                    } else {
                        p.reject(MembershipError.notFound)
                        return
                    }
                }).catch({ err in
                    p.reject(MembershipError.notFound)
                    return
                })
            }
        }
    }
    
    func loadMemberships() -> Promise<[Membership]> {
        return Promise<[Membership]> { p in
            DataHandler.def.getMyMemberships().done({ memberships in
                self.setMemberships(memberships: memberships)
                p.fulfill(memberships)
            }).catch({ err in
                p.reject(err)
            })
        }
    }
    
    private func getMembershipFromLocalMemberships(teamId: String) -> Membership? {
        let membershipIndex = self.memberships.firstIndex(where: { membership in
            return membership.team?.id == teamId
        })
        if (membershipIndex != nil && membershipIndex! >= 0 && membershipIndex! < memberships.count) {
            return memberships[membershipIndex!]
        }
        return nil
    }
    
    func storeSelectedMembership(membership:Membership?) {
        if let m = membership {
            Defaults[.selectedMembershipId] = m.id
        } else {
            Defaults[.selectedMembershipId] = ""
        }
    }
    
    func getPreviouslySelectedMembership() -> Membership? {
        let membershipId = Defaults[.selectedMembershipId]
        guard membershipId != "" else {
            return nil
        }
        
        let memberships = self.memberships
        
        if (memberships.count == 0) {
            return nil
        }
        
        if (memberships.count == 1) {
            selectedMembership = memberships[0]
            selectedMembership?.user = Authentication.getUser()
            return memberships[0]
        }
        
        let matchingMemberships = memberships.filter({ membership in
            return (membership.id == membershipId)
        })
        
        if (matchingMemberships.count > 0) {
            selectedMembership = matchingMemberships[0]
            selectedMembership?.user = Authentication.getUser()
            return matchingMemberships[0]
        }
        
        selectedMembership = nil
        return nil
        
    }
    
    func storeMemberships(memberships: [Membership]) {
        self.memberships = memberships
        Defaults[.membershipJSON] = memberships.toString()
    }
    
    private func getStoredMemberships() -> [Membership] {
        self.memberships = Defaults[.membershipJSON].toArray(Membership.self)
        return self.memberships
    }
    
    func clearMemberships() {
        Defaults[.membershipJSON] = ""
        Defaults[.selectedMembershipId] = ""
    }
    
}


extension DefaultsKeys {
    static let membershipJSON = DefaultsKey<String>("teams")
    static let selectedMembershipId = DefaultsKey<String>("selectedMembershipId")
}
