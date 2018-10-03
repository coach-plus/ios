//
//  ApiError.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 03.10.18.
//  Copyright © 2018 Mathandoro GbR. All rights reserved.
//

import Foundation
import PromiseKit

class ApiError: Error {
    
    var message: String?
    
    init(message: String) {
        self.message = message
    }
    
    init() {
        
    }
}
