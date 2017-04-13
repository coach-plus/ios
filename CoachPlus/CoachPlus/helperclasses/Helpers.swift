//
//  Helpers.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 25.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONable {
    init?(json: JSON)
}

protocol BackJSONable {
    func toJson() -> JSON
}

extension Array where Element:BackJSONable {
    func toJsonArray() -> [JSON] {
        return self.map({(element:BackJSONable) -> (JSON) in
            return element.toJson()
        })
    }
    
    func toStrings() -> [String] {
        return self.toJsonArray().toStringsArray()
    }
    
    func toString() -> String {
        
        var jsonArray = [JSON]()
        
        jsonArray = self.toStrings().map({itemString in
            return JSON(parseJSON: itemString)
        })
        
        return JSON(jsonArray).rawString()!
    }
}

extension Sequence where Iterator.Element == JSON {
    func toStringsArray() -> [String] {
        return self.map({(element:JSON) -> (String) in
            return element.rawString()!
        })
    }
}

extension String {
    func toObject<T:JSONable>(_ t:T.Type) -> T {
        let json = JSON(parseJSON: self)
        return T(json: json)!
    }
    
    func toArray<T:JSONable>(_ t:T.Type) -> [T] {
        let json = JSON(parseJSON: self)
        return json.arrayValue.map({json in
            return T(json: json)!
        })
    }
}
