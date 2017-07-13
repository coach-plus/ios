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
        return (jwt != nil && (jwt?.characters.count)! > 0)
    }
    
    
    static func storeJWT(jwt: String) -> Bool {
        
        do {
            let jwtObject = try decode(jwt: jwt)
            print(jwtObject)
            do {
                try Locksmith.deleteDataForUserAccount(userAccount: "main")
            } catch {
                
            }
            try Locksmith.saveData(data: [
                "jwt": jwt,
                "email": jwtObject.claim(name: "email").string,
                "id": jwtObject.claim(name: "id").string,
                "firstname": jwtObject.claim(name: "firstname").string,
                "lastname": jwtObject.claim(name: "lastname").string
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
    
    static func getJWT() -> String? {
        return getValue(key: "jwt") as! String?
    }
    
    static func getFirstname() -> String? {
        return getValue(key: "firstname") as! String?
    }
    
    static func getLastname() -> String? {
        return getValue(key: "lastname") as! String?
    }
    
    static func getEmail() -> String? {
        return getValue(key: "email") as! String?
    }
    
    static func getId() -> String? {
        return getValue(key: "id") as! String?
    }
    
    static func getUser() -> User {
        return User(id: getId()!, firstname: getFirstname()!, lastname: getLastname()!, email: getEmail()!)
    }
    
    static func logout() {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: "main")
        } catch {
            print("Failed to delete Data: \(error)")
        }
        FlowManager.goToLogin()
    }
    
}
