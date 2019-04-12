//
//  Helpers.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 25.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import SwiftyJSON
import MBProgressHUD

protocol JSONable {
    init?(json: JSON)
}

protocol BackJSONable {
    func toJson() -> JSON
}

extension Array where Element:Event {
    func upcoming() -> [Event] {
        return self.filterEvents(selection: .upcoming).sorted(by: {(eventA, eventB) in
            return eventA.start < eventB.start
        })
    }
    
    func past() -> [Event] {
        return self.filterEvents(selection: .past).sorted(by: {(eventA, eventB) in
            return eventA.end > eventB.end
        })
    }
    
    func filterEvents(selection: EventListViewController.Selection) -> [Event] {
        let filterPast = selection == .past
        let events = self.filter({event in
            return filterPast == event.isInPast()
        })
        return events
    }
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


extension MBProgressHUD {
    static func createHUD(view:UIView, msg:String) -> MBProgressHUD {
        let hud = MBProgressHUD(view: view)
        hud.graceTime = 0.5
        hud.detailsLabel.text = msg.localize()
        hud.mode = .indeterminate
        hud.animationType = .zoom
        view.addSubview(hud)
        hud.show(animated: true)
        return hud
    }
}
