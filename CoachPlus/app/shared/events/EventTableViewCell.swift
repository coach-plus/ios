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
    
    @IBOutlet weak var leftContainer: UIView!
    
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    func setup(event:Event) {
        
        //self.heroID = "event\(event.id)"
        
        let name = event.name
        
        self.nameLbl.text = name
        //self.nameLbl.heroID = "\(self.heroID!)/name"
        
        self.dateTimeLbl.text = event.fromToString()
        self.locationLbl.text = event.getLocationString()
        
        self.leftContainer.backgroundColor = UIColor.coachPlusLightBlue
    
        self.monthLbl.text = event.start.monthName()
        self.dayLbl.text = event.start.dayOfMonth()
        
        self.monthLbl.textColor = UIColor.coachPlusBlue
        self.dayLbl.textColor = UIColor.coachPlusBlue
        
        self.leftContainer.layer.cornerRadius = 5
        self.leftContainer.clipsToBounds = true
        
    }
    
}
