//
//  InviteResponse.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 29.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import SwiftyJSON


class InviteResponse:JSONable {

    
    var url: String
    
    init(url:String) {
        self.url = url    }
    
    required init(json:JSON) {
        self.url = json["url"].stringValue
    }
}
