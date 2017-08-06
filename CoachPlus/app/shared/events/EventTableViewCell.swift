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
        
        //self.heroID = "event\(event.id)"
        
        let name = event.name
        let date = event.dateString()
        
        var nameString = NSMutableAttributedString(string: "\(name) \(date)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15, weight: UIFontWeightSemibold)])
        
        let attributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular),
            NSForegroundColorAttributeName: UIColor.coachPlusLightGrey
        ]
        
        nameString.addAttributes(attributes, range: NSRange(location: name.characters.count+1, length: date.characters.count))
        
        self.nameLbl.attributedText = nameString
        //self.nameLbl.heroID = "\(self.heroID!)/name"
        
        
        self.dateTimeLbl.text = event.fromToString()
        self.locationLbl.text = event.getLocationString()
        
        
    }
}
