//
//  Authentication.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 25.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import Locksmith
import JWTDecode

class Authentication {
    
    static func loggedIn() -> Bool {
        let jwt = getJWT()
        return (jwt != nil && (jwt?.count)! > 0)
    }
    
    
    static func storeJWT(jwt: String) -> Bool {
        
        do {
            let jwtObject = try decode(jwt: jwt)
            print(jwtObject)
            do {
                try Locksmith.deleteDataForUserAccount(userAccount: "main")
            } catch {
                
            }
            
            let user = User(id: jwtObject.claim(name: "_id").string!, firstname: jwtObject.claim(name: "firstname").string!, lastname: jwtObject.claim(name: "lastname").string!, email: jwtObject.claim(name: "email").string!, image: jwtObject.claim(name: "image").string, emailVerified: false)
            UserManager.storeUser(user: user)

            try Locksmith.saveData(data: [
                "jwt": jwt
                ], forUserAccount: "main")
            return true
        } catch {
            print("Failed to decode JWT: \(error)")
            return false
        }
    }
    
    static func getDict() -> Dictionary<String, Any>? {
        return Locksmith.loadDataForUserAccount(userAccount: "main")
    }
    
    static func getValue(key: String) -> Any? {
        return getDict()?[key]
    }
    
    static func setValues(dict: Dictionary<String, Any>) -> Bool {
        var existingDict = getDict()
        dict.forEach({ (key, value) in
            existingDict![key] = value
        })
        do {
            try Locksmith.saveData(data: dict, forUserAccount: "main")
            return true
        } catch {
            return false
        }
    }
    
    static func getJWT() -> String? {
        return getValue(key: "jwt") as! String?
    }
    
    static func getUser() -> User {
        return UserManager.getUser()
    }
    
    
    static func logout() {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: "main")
        } catch {
            print("Failed to delete Data: \(error)")
        }
        MembershipManager.shared.clearMemberships()
        FlowManager.goToLogin(completion: {
            MembershipManager.shared.membershipsSubject.onNext([])
            MembershipManager.shared.selectedMembershipSubject.onNext(nil)
        })
    }
    
}
