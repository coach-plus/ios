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
    
    enum Mode {
        case Edit
        case View
    }

    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var interactionContainerView: UIView!
    
    var participationView: ParticipationView?
    var participationStatusView: ParticipationStatus?
    
    var participationItem:ParticipationItem?
    var event:Event?
    var delegate: ParticipationTableViewCellDelegate?
    var mode: Mode = Mode.View
    
    func configure(delegate: ParticipationTableViewCellDelegate?, participationItem:ParticipationItem, event:Event) {
        self.participationItem = participationItem
        self.delegate = delegate
        
        if (event.hasStarted()) {
            self.mode = Mode.View
        } else {
            if (participationItem.user?.id == Authentication.getUser().id) {
                self.mode = Mode.Edit
            } else {
                self.mode = Mode.View
            }
        }
        
        self.imageV.setUserImage(user: (self.participationItem?.user)!)
        self.nameLbl.text = self.participationItem?.user?.fullname
        self.event = event
        
        let frame = self.interactionContainerView.frame
        
        if (self.mode == Mode.Edit) {
            
            self.participationView = ParticipationView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
            self.participationView!.configure(participationItem: participationItem, event: event)
            self.participationView!.delegate = self
            self.interactionContainerView.addSubview(self.participationView!)
            
        } else {
            
            self.participationStatusView = ParticipationStatus(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
            
            var status: Participation.Status
            
            if (self.participationItem?.participation != nil && self.event != nil) {
                status = self.participationItem!.participation!.getStatus(event: self.event!)
            } else {
                status = Participation.Status.unknown
            }
            
            self.participationStatusView?.configure(status: status)
            
            self.interactionContainerView.addSubview(self.participationStatusView!)
            
            
            
            //self.interactionContainerView.backgroundColor = UIColor.green
        }
    }
    
    func setBackgroundColor() {
        if (event!.hasStarted() &&  (participationItem!.participation == nil || !participationItem!.participation!.statusIsPositive())) {
            self.contentView.backgroundColor = UIColor.coachPlusParticipationWrongColor
        } else {
            self.contentView.backgroundColor = UIColor.white
        }
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
        self.setBackgroundColor()
        if self.delegate != nil {
            self.delegate!.participationChanged()
        }
    }
    
    
}
