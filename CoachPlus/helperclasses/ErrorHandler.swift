//
//  ErrorHandler.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 12.04.19.
//  Copyright © 2019 Mathandoro GbR. All rights reserved.
//

import Foundation

protocol ErrorHandlerDelegate {
    func handleApiError(apiError: ApiError)
    func handleGeneralError(error: Error)
}

class ErrorHandler {
    
    var delegate: ErrorHandlerDelegate?
    
    init(delegate: ErrorHandlerDelegate) {
        self.delegate = delegate
    }
    
    func handleError(error: Error) {
        if let apiError = error as? ApiError {
            self.delegate?.handleApiError(apiError: apiError)
        } else {
            self.delegate?.handleGeneralError(error: error)
        }
    }
    
}
