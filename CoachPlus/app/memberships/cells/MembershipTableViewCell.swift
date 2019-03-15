//
//  TeamTableViewCell.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 29.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit


protocol MembershipTableViewCellActionDelegate {
    func showActions(membership: Membership, mode: MembershipTableViewCell.Mode)
}



class MembershipTableViewCell: UITableViewCell {
    
    public enum Mode{
        case Join
        case Leave
        case None
    }
    
    @IBOutlet weak var leftLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var imageV: CoachPlusImageView!
    
    @IBOutlet weak var moreBtn: UIButton!
    
    @IBAction func moreBtnTapped(_ sender: Any) {
        if (self.actionDelegate != nil && self.membership != nil) {
            self.actionDelegate?.showActions(membership: self.membership!, mode: self.mode)
        }
    }
    
    var actionDelegate: MembershipTableViewCellActionDelegate?
    var membership: Membership?
    
    var mode: Mode = Mode.None
    
    var inMembershipList: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setup(membership:Membership) {
        self.membership = membership
        self.leftLbl.text = membership.team!.name
        
        self.descriptionLbl.text = membership.team?.getMemberCountString()
        
        self.moreBtn.setTitle("", for: .normal)
        self.moreBtn.isHidden = true
        
        if (self.inMembershipList == false) {
            if (UserManager.isSelf(userId: membership.user?.id)) {
                self.moreBtn.setCoachPlusIcon(fontType: .fontAwesomeSolid(.signOutAlt), color: UIColor.leaveTeamRed)
                self.moreBtn.isHidden = false
                self.mode = Mode.Leave
            } else {
                if (membership.joined == true) {
                    self.mode = Mode.None
                } else {
                    self.moreBtn.setCoachPlusIcon(fontType: .fontAwesomeSolid(.signInAlt), color: .coachPlusBlue)
                    self.moreBtn.isHidden = false
                    self.mode = Mode.Join
                }
            }
        }
        
        self.imageV.setIsPrivate(isPrivate: (membership.team?.isPublic)! == false)
        self.imageV.imageView.setTeamImage(team: membership.team!, placeholderColor: nil)
    }
    
}
