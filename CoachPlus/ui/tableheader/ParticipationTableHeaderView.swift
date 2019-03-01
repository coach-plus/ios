//
//  ParticipationTableHeaderView.swift
//  CoachPlus
//
//  Created by Maurice Breit on 23.06.18.
//  Copyright © 2018 Mathandoro GbR. All rights reserved.
//

import UIKit
import NibDesignable
import SwiftIcons

class ParticipationTableHeaderView: NibDesignable {

    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var unknownL: UILabel!
    @IBOutlet weak var yesL: UILabel!
    @IBOutlet weak var noL: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var participations = [ParticipationItem]()
    var eventIsInPast: Bool = false
    
    func initLabels() {
        self.unknownL.text = ""
        self.yesL.text = ""
        self.noL.text = ""
    }
    
    func setTitle(title: String) {
        self.titleL.text = title
    }
    
    func setLabels(participations: [ParticipationItem]?) {
        guard participations != nil else {
            self.initLabels()
            return
        }
        
        self.participations = participations!
        
        
        self.showParticipationNumbers()
        
    }
    
    
    func showParticipationNumbers() {
        let unknownCount = self.participations.filter {
            $0.participation == nil || $0.participation!.getValue(eventIsInPast: self.eventIsInPast) == nil
            }.count
        
        let yesCount = self.participations.filter {
            $0.participation != nil && $0.participation!.getValue(eventIsInPast: self.eventIsInPast) == true
            }.count
        
        let noCount = self.participations.filter {
            $0.participation != nil && $0.participation!.getValue(eventIsInPast: self.eventIsInPast) == false
            }.count
        
        self.setLabel(label: self.unknownL, icon: .fontAwesomeSolid(.questionCircle), count: unknownCount, iconColor: UIColor.coachPlusBlue)
        self.setLabel(label: self.yesL, icon: .fontAwesomeSolid(.checkCircle), count: yesCount, iconColor: UIColor.coachPlusParticipationYesColor)
        self.setLabel(label: self.noL, icon: .fontAwesomeSolid(.timesCircle), count: noCount, iconColor: UIColor.coachPlusParticipationNoColor)
        
        if (unknownCount == 0) {
            self.unknownL.isHidden = true
        } else {
            self.unknownL.isHidden = false
        }
    }
    
    func setLabel(label: UILabel, icon: FontType, count: Int, iconColor: UIColor) {
        let color = self.titleL.textColor
        label.setIcon(prefixText: "", prefixTextColor: color!, icon: icon, iconColor: iconColor, postfixText:" \(count)", postfixTextColor: color!, size: 15, iconSize: 15)
    }
    
    func refresh() {
        self.showParticipationNumbers()
    }
    
    
    
}
