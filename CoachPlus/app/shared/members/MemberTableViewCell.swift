//
//  MemberTableViewCell.swift
//  CoachPlus
//
//  Created by Maurice Breit on 14.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit

protocol MemberTableViewCellDelegate {
    func dataChanged()
}

class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var imageV: CoachPlusImageView!

    @IBOutlet weak var textLbl: UILabel!
    
    @IBOutlet weak var actionBtn: UIButton!
    
    var ownMembership:Membership?
    var membership: Membership?
    var vc:CoachPlusViewController?
    var delegate: MemberTableViewCellDelegate?
    
    @IBAction func actionBtnTapped(_ sender: Any) {
        if let isCoach = self.ownMembership?.isCoach(), isCoach != true {
            return
        }
        self.showActions()
    }
    
    
    func setup(membership: Membership, ownMembership: Membership, vc:CoachPlusViewController) {
        
        self.vc = vc
        self.ownMembership = ownMembership
        self.membership = membership
        self.delegate = vc as? MemberTableViewCellDelegate
        
        let heroID = "\(membership.user!.id)"
        self.imageV.heroID = "\(heroID)/image"
        self.textLbl.heroID = "\(heroID)/text"
        
        self.textLbl.text = membership.user?.fullname
        self.textLbl.textColor = UIColor.defaultText
        
        self.imageV.imageView.setUserImage(user: membership.user!)
        self.imageV.setIsCoach(isCoach: membership.isCoach())
        
        let isCoach = self.ownMembership?.isCoach()
        
        if (isCoach != nil && isCoach != true || self.ownMembership?.id == self.membership?.id) {
            self.actionBtn.isHidden = true
        } else {
            self.actionBtn.isHidden = false
            self.actionBtn.setTitle("", for: .normal)
            self.actionBtn.setCoachPlusIcon(fontType: .ionicons(.more), color: .coachPlusBlue)
            
            //self.actionBtn.setIcon(icon: .ionicons(.more), iconSize: 20.0, color: .coachPlusBlue, backgroundColor: .clear, forState: .normal)
        }
    }
    
    func showActions() {
        let alertController = UIAlertController(title: L10n.actions, message: L10n.pleaseSelectAnAction, preferredStyle: .actionSheet)
        
        let makeCoach = UIAlertAction(title: L10n.makeCoach, style: .default, handler: { (action) -> Void in
            
            self.vc?.loadData(text: L10n.loading, promise: DataHandler.def.setRole(membershipId: self.membership!.id, role: Membership.Role.coach.rawValue)).done({ response in
                self.delegate?.dataChanged()
            })
        })
        
        let makeUser = UIAlertAction(title: L10n.makeUser, style: .default, handler: { (action) -> Void in
            self.vc?.loadData(text: L10n.loading, promise: DataHandler.def.setRole(membershipId: self.membership!.id, role: Membership.Role.user.rawValue)).done({ response in
                self.delegate?.dataChanged()
            })
        })
        
        let  deleteButton = UIAlertAction(title: L10n.removeFromTeam, style: .destructive, handler: { (action) -> Void in
            self.vc?.loadData(text: L10n.loading, promise: DataHandler.def.removeUserFromTeam(membershipId: self.membership!.id)).done({ response in
                self.delegate?.dataChanged()
            }).catch({ err in
                print(err)
            })
        })
        
        let cancelButton = UIAlertAction(title: L10n.cancel, style: .cancel, handler: { (action) -> Void in
            
        })
        
        if (self.membership!.isCoach()) {
            alertController.addAction(makeUser)
        } else {
            alertController.addAction(makeCoach)
        }
        
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.vc?.presentModally(alertController, animated: true, completion: nil)
        
    }
    
    func handleError(_ error: Error) {
        // do somethign
    }
    
}
