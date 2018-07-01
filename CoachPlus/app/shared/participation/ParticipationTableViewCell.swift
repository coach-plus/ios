//
//  ParticipationTableViewCell.swift
//  CoachPlus
//
//  Created by Maurice Breit on 17.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit

protocol ParticipationTableViewCellDelegate {
    func participationChanged()
}

class ParticipationTableViewCell: UITableViewCell, ParticipationViewDelegate {

    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var participationView: ParticipationView!
    
    var participationItem:ParticipationItem?
    var event:Event?
    var delegate: ParticipationTableViewCellDelegate?
    
    func configure(delegate: ParticipationTableViewCellDelegate?, participationItem:ParticipationItem, event:Event) {
        self.participationItem = participationItem
        self.delegate = delegate
        self.participationView.configure(participationItem: participationItem, event: event)
        self.participationView.delegate = self
        self.imageV.setUserImage(user: (self.participationItem?.user)!)
        self.nameLbl.text = self.participationItem?.user?.fullname
    }
    
    //not called
    func selected(attend: Bool) {
        
        if let membership = MembershipManager.shared.selectedMembership {
            let now = Date()
            if (now < (self.event?.start)!) {
                self.participationItem?.participation?.willAttend = attend
            } else {
                if (membership.isCoach()) {
                    self.participationItem?.participation?.didAttend = attend
                }
            }
        }
        
        self.reload()
    }
    
    func reload() {
        self.configure(delegate: self.delegate, participationItem: self.participationItem!, event: self.event!)
    }
    
    func dataChanged() {
        if self.delegate != nil {
            self.delegate!.participationChanged()
        }
    }
    
    
}
