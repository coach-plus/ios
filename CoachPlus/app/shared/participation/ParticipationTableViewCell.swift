//
//  ParticipationTableViewCell.swift
//  CoachPlus
//
//  Created by Maurice Breit on 17.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit

class ParticipationTableViewCell: UITableViewCell, ParticipationViewDelegate {

    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var participationView: ParticipationView!
    
    var participation:Participation?
    var mode: ParticipationView.Mode = .willAttend
    
    
    
    func configure(mode:ParticipationView.Mode, participation:Participation) {
        self.mode = mode
        self.participation = participation
        self.participationView.delegate = self
        self.participationView.mode = self.mode
        self.participationView.configure(participation: self.participation!)
        self.participation?.user?.setImage(imageV: self.imageV)
        self.nameLbl.text = self.participation?.user?.fullname
    }
    
    func selected(yes: Bool) {
        switch self.mode {
        case .didAttend:
            self.participation?.didAttend = yes
        case .willAttend:
            self.participation?.willAttend = yes
        }
        self.configure(mode: self.mode, participation: self.participation!)
    }
    
    
}
