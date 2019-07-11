//
//  Environment.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 02.07.19.
//  Copyright © 2019 Mathandoro GbR. All rights reserved.
//

import Foundation
public enum Environment {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    static let backendURL: URL = {
        guard let backendUrlString = Environment.infoDictionary["BACKEND_URL"] as? String else {
            fatalError("BACKEND_URL not set in plist for this environment")
        }
        guard let url = URL(string: backendUrlString) else {
            fatalError("BACKEND_URL is invalid")
        }
        return url
    }()
}
