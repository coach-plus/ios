//
//  MemberTableViewCell.swift
//  CoachPlus
//
//  Created by Maurice Breit on 14.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import AlamofireImage

class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var imageV: UIImageView!

    @IBOutlet weak var textLbl: UILabel!
    
    @IBOutlet weak var coachLogoIv: UIImageView!
    
    @IBOutlet weak var actionBtn: UIButton!
    
    var ownMembership:Membership?
    var vc:UIViewController?
    
    @IBAction func actionBtnTapped(_ sender: Any) {
        if let isCoach = self.ownMembership?.isCoach(), isCoach != true {
            return
        }
        self.showActions()
    }
    
    
    func setup(membership: Membership, ownMembership: Membership, vc:UIViewController) {
        
        self.vc = vc
        self.ownMembership = ownMembership
        
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
        
        if let isCoach = self.ownMembership?.isCoach(), isCoach != true {
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
        
        let sendButton = UIAlertAction(title: "ACTION_MAKE_COACH".localize(), style: .default, handler: { (action) -> Void in
        })
        
        let  deleteButton = UIAlertAction(title: "ACTION_KICK_USER".localize(), style: .destructive, handler: { (action) -> Void in
            
        })
        
        let cancelButton = UIAlertAction(title: "CANCEL".localize(), style: .cancel, handler: { (action) -> Void in
            
        })
        
        
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.vc?.present(alertController, animated: true, completion: nil)
        
    }
    
}
