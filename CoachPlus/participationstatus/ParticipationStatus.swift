//
//  ParticipationStatus.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 03.10.18.
//  Copyright © 2018 Mathandoro GbR. All rights reserved.
//

import UIKit
import NibDesignable

class ParticipationStatus: NibDesignable {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.containerView.layer.borderWidth = 2.0
        self.containerView.layer.cornerRadius = 5.0
    }
    
    func configure(status: Participation.Status) {
        var text: String
        var color: UIColor
        
        switch status {
        case .didAttend:
            text = "DID_ATTEND"
            color = UIColor.coachPlusParticipationYesColor
            break
        case .didNotAttend:
            text = "DID_NOT_ATTEND"
            color = UIColor.coachPlusParticipationNoColor
            break
        case .didNotAttendUnexcused:
            text = "DID_NOT_ATTEND_UNEXCUSED"
            color = UIColor.coachPlusParticipationWrongColor
            break
        case .willNotAttend:
            text = "WILL_NOT_ATTEND"
            color = UIColor.coachPlusParticipationNoColor
            break
        case .willAttend:
            text = "WILL_ATTEND"
            color = UIColor.coachPlusParticipationYesColor
            break
        case .unknown:
            text = "UNKNOWN"
            color = UIColor.unselectedColor
            break
        }
        
        self.textLbl.textColor = color
        self.textLbl.text = text.localize()
        self.containerView.layer.borderColor = color.cgColor
        
    }
}
