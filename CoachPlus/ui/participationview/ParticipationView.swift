//
//  ParticipationView.swift
//  CoachPlus
//
//  Created by Maurice Breit on 17.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit
import SwiftIcons
import NibDesignable

protocol ParticipationViewDelegate {
    func selected(attend:Bool)
    func dataChanged()
}

class ParticipationView: NibDesignable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    var delegate: ParticipationViewDelegate?
    
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    
    @IBOutlet weak var yesBg: UIView!
    @IBOutlet weak var noBg: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var participation: Participation?
    var event: Event?
    var user: User?
    var membership: Membership?
    
    static let selectedYesColor = UIColor.coachPlusParticipationYesColor
    static let selectedNoColor = UIColor.coachPlusParticipationNoColor
    static let didAttendNoColor = UIColor.coachPlusParticipationWrongColor
    static let unselectedColor = UIColor(hexString: "9b9b9b")
    
    static let noBgColor = UIColor(hexString: "ffffff")
    
    @IBAction func yesTap(_ sender: Any) {
        //delegate?.selected(attend: true)
        self.selected(attend: true)
    }
    
    @IBAction func noTap(_ sender: Any) {
        //delegate?.selected(attend: false)
        self.selected(attend: false)
    }
    
    func setup() {
        self.yesBtn.setIcon(icon: .googleMaterialDesign(.check), iconSize: 20, color: .coachPlusLightGrey, backgroundColor: .clear, forState: .normal)
        self.noBtn.setIcon(icon: .googleMaterialDesign(.close), iconSize: 20, color: .coachPlusLightGrey, backgroundColor: .clear, forState: .normal)
    }
    
    func configure(participationItem:ParticipationItem, event:Event) {
        self.event = event
        self.user = participationItem.user!
        
        if participationItem.participation != nil {
            self.participation = participationItem.participation
        } else {
            self.participation = Participation(user: (participationItem.user?.id)!, event: event.id, willAttend: nil, didAttend: nil)
        }
        
        self.membership = MembershipManager.shared.selectedMembership
        
        if (self.event!.hasStarted() && !self.membership!.isCoach()) {
            yesBtn.isEnabled = false
            noBtn.isEnabled = false
        }
        
        let loggedInUser = Authentication.getUser()
        
        if (!(self.event?.hasStarted())! && self.user?.id != loggedInUser.id) {
            yesBtn.isEnabled = false
            noBtn.isEnabled = false
        }
        
        self.showData()
        self.isHidden = false
        
    }
    
    func showData() {
        showWillAttend()
        showDidAttend()
        self.yesBg.isHidden = false
        self.noBg.isHidden = false
        self.hideActivityIndicator()
    }
    
    
    func setTitleColorOnButton(btn:UIButton, color:UIColor) {
        btn.setTitleColor(color, for: .normal)
    }
    
    
    func showWillAttend() {
        setTitleColorOnButton(btn: yesBtn, color: ParticipationView.unselectedColor)
        setTitleColorOnButton(btn: noBtn, color: ParticipationView.unselectedColor)
        if let willAttend = self.participation?.willAttend {
            if (willAttend == true) {
                setTitleColorOnButton(btn: yesBtn, color: ParticipationView.selectedYesColor)
            } else {
                setTitleColorOnButton(btn: noBtn, color: ParticipationView.selectedNoColor)
            }
        }
    }
    
    func showDidAttend() {
        yesBg.backgroundColor = ParticipationView.noBgColor
        noBg.backgroundColor = ParticipationView.noBgColor
        if let didAttend = self.participation?.didAttend {
            if (didAttend == false) {
                yesBg.backgroundColor = ParticipationView.didAttendNoColor
            }
        }
        
    }
    
    func selected(attend:Bool) {
        if (!(event?.hasStarted())! && (self.participation?.willAttend == nil || self.participation?.willAttend != attend)) {
            setWillAttend(willAttend: attend)
        } else {
            if (membership!.isCoach() && self.participation?.didAttend != attend) {
                self.setDidAttend(didAttend: attend)
            }
        }
    }
    
    func showActivityIndicator() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        self.yesBg.isHidden = true
        self.noBg.isHidden = true
    }
    
    func hideActivityIndicator() {
        self.activityIndicator.stopAnimating()
    }
    
    func setWillAttend(willAttend:Bool) {
        
        self.showActivityIndicator()
        
        _ = DataHandler.def.willAttend(teamId: (self.event?.teamId)!, eventId: (self.event?.id)!, userId: (self.user?.id)!, willAttend: willAttend, successHandler: { res in
            self.participation?.willAttend = willAttend
            self.showData()
            self.dataChanged()
        }, failHandler: { err in
            self.showData()
        })
    }
    
    func setDidAttend(didAttend:Bool) {
        
        self.showActivityIndicator()
        
        _ = DataHandler.def.didAttend(event: (self.event)!, user: self.user!, didAttend: didAttend, successHandler: { res in
            self.participation?.didAttend = didAttend
            self.showData()
            self.dataChanged()
        }, failHandler: { err in
            self.showData()
        })
    }
    
    func dataChanged() {
        guard self.delegate != nil else {
            return
        }
        
        self.delegate!.dataChanged()
    }
    
}
