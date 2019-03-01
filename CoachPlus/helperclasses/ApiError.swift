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
    
    var message: String
    var statusCode: Int
    
    init(message: String, statusCode: Int) {
        self.message = message
        self.statusCode = statusCode
    }
}
