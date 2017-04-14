//
//  EventTableViewCell.swift
//  CoachPlus
//
//  Created by Maurice Breit on 13.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import SwiftDate

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    func setup(event:Event) {
        self.nameLbl.text = event.name
        self.dateTimeLbl.text = "\(event.start.string(dateStyle: .short, timeStyle: .short, in: nil)) - \(event.end.string(dateStyle: .none, timeStyle: .short, in: nil))"
        self.locationLbl.text = event.description
    }
}
