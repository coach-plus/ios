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
        
        let unknownCount = participations!.filter {
            $0.participation == nil || $0.participation!.willAttend == nil
        }.count
        
        let yesCount = participations!.filter {
            $0.participation != nil && $0.participation!.willAttend == true
        }.count
        
        let noCount = participations!.filter {
            $0.participation != nil && $0.participation!.willAttend == false
        }.count
        
        self.setLabel(label: self.unknownL, icon: .fontAwesome(.question), count: unknownCount, iconColor: self.titleL.textColor)
        self.setLabel(label: self.yesL, icon: .fontAwesome(.check), count: yesCount, iconColor: UIColor.coachPlusParticipationYesColor)
        self.setLabel(label: self.noL, icon: .fontAwesome(.times), count: noCount, iconColor: UIColor.coachPlusParticipationNoColor.darkerColor(percent: 0.25))
        
    }
    
    func setLabel(label: UILabel, icon: FontType, count: Int, iconColor: UIColor) {
        let color = self.titleL.textColor
        label.setIcon(prefixText: "", prefixTextColor: color!, icon: icon, iconColor: iconColor, postfixText:" \(count)", postfixTextColor: color!, size: 15, iconSize: 15)
    }
    
    
    
}
