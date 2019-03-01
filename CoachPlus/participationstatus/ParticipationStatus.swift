//
//  ParticipationStatus.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 03.10.18.
//  Copyright © 2018 Mathandoro GbR. All rights reserved.
//

import UIKit
import NibDesignable
import SwiftIcons

protocol ParticipationStatusDelegate{
    func didTapParticipationStatus()
}

class ParticipationStatus: NibDesignable {
    
    public static let statusIconSize: CGFloat = 30.0
    
    var participationItem: ParticipationItem?
    var event: Event?
    var delegate: ParticipationTableViewCellDelegate?

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textLbl: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func statusTapped(_ sender: Any) {
        if (MembershipManager.shared.selectedMembership?.isCoach() ?? false) {
            self.showActionSheet()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.hideActivityIndicator()
    }
    
    func configure(participation: ParticipationItem, event: Event, delegate: ParticipationTableViewCellDelegate?) {
        self.participationItem = participation
        self.event = event
        self.delegate = delegate
        
        self.showData()
    }
    
    func showData() {
        
        var status: Participation.Status
        
        if (self.participationItem?.participation != nil && self.event != nil) {
            status = self.participationItem!.participation!.getStatus(event: self.event!)
        } else {
            status = Participation.Status.unknown
        }
        
        var color: UIColor
        
        var icon: FontType?
        
        switch status {
        case .didAttend:
            icon = FontType.fontAwesomeSolid(.checkCircle)
            color = UIColor.coachPlusParticipationYesColor
            break
        case .didNotAttend:
            icon = FontType.fontAwesomeSolid(.timesCircle)
            color = UIColor.coachPlusParticipationDidNotAttendColor
            break
        case .didNotAttendUnexcused:
            icon = FontType.fontAwesomeSolid(.exclamationCircle)
            color = UIColor.coachPlusParticipationWrongColor
            break
        case .willNotAttend:
            icon = FontType.fontAwesomeSolid(.timesCircle)
            color = UIColor.coachPlusParticipationNoColor
            break
        case .willAttend:
            icon = FontType.fontAwesomeSolid(.checkCircle)
            color = UIColor.coachPlusParticipationYesColor
            break
        case .unknown:
            icon = FontType.fontAwesomeSolid(.questionCircle)
            color = UIColor.coachPlusBlue
            break
        }
        
        self.textLbl.setCoachPlusIcon(fontType: icon!, color: color, size: ParticipationStatus.statusIconSize)
        
        self.hideActivityIndicator()
    }
    
    func setDidAttend(didAttend:Bool) {
        
        self.showActivityIndicator()
        
        DataHandler.def.didAttend(event: (self.event)!, user: self.participationItem!.user!, didAttend: didAttend).done({ res in
            self.participationItem?.participation?.didAttend = didAttend
            self.showData()
            if (self.delegate != nil) {
                self.delegate?.participationChanged()
            }
        }).catch({ err in
            self.showData()
        })
    }
    
    func showActivityIndicator() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        //self.textLbl.titleLabel?.text = ""
        //self.textLbl.isHidden = true
    }
    
    func hideActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        
        //self.textLbl.isHidden = false
    }
    
    func showActionSheet() {
        let alertController = UIAlertController(title: "SET_ATTENDANCE".localize(), message: "SET_ATTENDANCE_MESSAGE".localize(), preferredStyle: .actionSheet)
        
        let yesButton = UIAlertAction(title: "DID_ATTEND".localize(), style: .default, handler: { (action) -> Void in
            self.setDidAttend(didAttend: true)
        })
        
        let noButton = UIAlertAction(title: "DID_NOT_ATTEND".localize(), style: .default, handler: { (action) -> Void in
            self.setDidAttend(didAttend: false)
        })
        
        let cancelButton = UIAlertAction(title: "CANCEL".localize(), style: .cancel, handler: { (action) -> Void in })
        
        if (self.participationItem?.participation?.didAttend != true) {
            alertController.addAction(yesButton)
        }
        
        if (self.participationItem?.participation?.didAttend != false) {
            alertController.addAction(noButton)
        }
        
        alertController.addAction(cancelButton)
        
        if let vc = self.delegate as? UIViewController, vc != nil {
            vc.present(alertController, animated: true, completion: nil)
        }
        
        
    }
}
