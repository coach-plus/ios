//
//  Location.swift
//  CoachPlus
//
//  Created by Maurice Breit on 05.08.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import SwiftyJSON

class Location {

    enum Fields:String {
        case name = "name"
        case lat = "lat"
        case long = "long"
    }
    
    var name: String
    var lat: Double?
    var long: Double?
    
    init(name:String, lat:Double, long:Double) {
        self.name = name
        self.lat = lat
        self.long = long
    }
    
    required init(json:JSON) {
        self.name = json[Fields.name.rawValue].stringValue
        self.lat = json[Fields.lat.rawValue].double
        self.long = json[Fields.long.rawValue].double
    }
    
    func toJson() -> JSON {
        let json: JSON = [
            Fields.name.rawValue: self.name,
            Fields.lat.rawValue: self.lat,
            Fields.long.rawValue: self.long]
        return json
    }
    
    func getLocationString() -> String {
        return self.name
    }
}
