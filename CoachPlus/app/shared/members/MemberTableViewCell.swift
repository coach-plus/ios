//
//  MemberTableViewCell.swift
//  CoachPlus
//
//  Created by Maurice Breit on 14.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import AlamofireImage

protocol MemberTableViewCellDelegate {
    func dataChanged()
}

class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var imageV: UIImageView!

    @IBOutlet weak var textLbl: UILabel!
    
    @IBOutlet weak var coachLogoIv: UIImageView!
    
    @IBOutlet weak var actionBtn: UIButton!
    
    var ownMembership:Membership?
    var membership: Membership?
    var vc:UIViewController?
    var delegate: MemberTableViewCellDelegate?
    
    @IBAction func actionBtnTapped(_ sender: Any) {
        if let isCoach = self.ownMembership?.isCoach(), isCoach != true {
            return
        }
        self.showActions()
    }
    
    
    func setup(membership: Membership, ownMembership: Membership, vc:UIViewController) {
        
        self.vc = vc
        self.ownMembership = ownMembership
        self.membership = membership
        self.delegate = vc as? MemberTableViewCellDelegate
        
        let heroID = "\(membership.user!.id)"
        self.imageV.heroID = "\(heroID)/image"
        self.textLbl.heroID = "\(heroID)/text"
        
        textLbl.text = membership.user?.fullname
        self.imageV.setUserImage(user: membership.user!)
        
        if (membership.isCoach()) {
            coachLogoIv.image = UIImage(named: "CoachLogo")
            coachLogoIv.isHidden = false
        } else {
            coachLogoIv.isHidden = true
        }
        
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
        let alertController = UIAlertController(title: "ACTIONS".localize(), message: "ACTIONS_WHAT_TO_DO".localize(), preferredStyle: .actionSheet)
        
        let makeCoach = UIAlertAction(title: "ACTION_MAKE_COACH".localize(), style: .default, handler: { (action) -> Void in
            
            self.vc?.loadData(text: "LOAD_DATA", promise: DataHandler.def.setRole(membershipId: self.membership!.id, role: Membership.Role.coach.rawValue)).done({ response in
                self.delegate?.dataChanged()
            })
        })
        
        let makeUser = UIAlertAction(title: "ACTION_MAKE_USER".localize(), style: .default, handler: { (action) -> Void in
            self.vc?.loadData(text: "LOAD_DATA", promise: DataHandler.def.setRole(membershipId: self.membership!.id, role: Membership.Role.user.rawValue)).done({ response in
                self.delegate?.dataChanged()
            })
        })
        
        let  deleteButton = UIAlertAction(title: "ACTION_KICK_USER".localize(), style: .destructive, handler: { (action) -> Void in
            
        })
        
        let cancelButton = UIAlertAction(title: "CANCEL".localize(), style: .cancel, handler: { (action) -> Void in
            
        })
        
        if (self.membership!.isCoach()) {
            alertController.addAction(makeUser)
        } else {
            alertController.addAction(makeCoach)
        }
        
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.vc?.present(alertController, animated: true, completion: nil)
        
    }
    
}
