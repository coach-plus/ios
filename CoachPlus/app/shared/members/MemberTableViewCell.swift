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
    
    func setup(membership: Membership) {
        textLbl.text = membership.user?.fullname
        self.imageV.setUserImage(user: membership.user!)
        
        if (membership.isCoach()) {
            coachLogoIv.image = UIImage(named: "CoachLogo")
            coachLogoIv.isHidden = false
        } else {
            coachLogoIv.isHidden = true
        }
    }
    
}
