//
//  StringExtension.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 25.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation

extension String {
    
    var isValidEmail:Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    
    // http://stackoverflow.com/questions/30799543/how-to-parse-mongodb-datetime-iso-date-to-nsdate-on-ios-swift-and-objective
    
    func toDate() -> Date {
        let formatter = DateFormatter()
        
        // Format 1
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let parsedDate = formatter.date(from: self) {
            return parsedDate
        }
        
        // Format 2
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SSSZ"
        if let parsedDate = formatter.date(from: self) {
            return parsedDate
        }
        
        // Couldn't parse with any format. Just get the date
        let splitedDate = self.components(separatedBy: "T")
        if splitedDate.count > 0 {
            formatter.dateFormat = "yyyy-MM-dd"
            if let parsedDate = formatter.date(from: splitedDate[0]) {
                return parsedDate
            }
        }
        
        // Nothing worked!
        return Date()
    }
    
    func localize() -> String {
        let translated = Bundle.main.localizedString(forKey: self, value: "", table: "MainLocalization")
        return translated
    }
}
