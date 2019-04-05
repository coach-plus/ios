//
//  DateExtension.swift
//  CoachPlus
//
//  Created by Maurice Breit on 13.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation

extension Date {
    
    func toTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.string(from: self)
    }
    
    func toFormatted(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func simpleFormatted() -> String {
        return self.toFormatted(format: "dd.MM.YY - HH:mm")
    }
    
    func timeShort() -> String {
        return self.toFormatted(format: "HH:mm")
    }
    
    func dateShort() -> String {
        return self.toFormatted(format: "dd.MM.YY")
    }
    
    func toDefaultFormatted() -> String {
        return self.toFormatted(format: "EEE dd.MM.YY - HH:mm")
    }
    
    func dayOfMonth() -> String {
        return self.toFormatted(format: "dd")
    }
    
    func monthName() -> String {
        return self.toFormatted(format: "MMMM")
    }
}
