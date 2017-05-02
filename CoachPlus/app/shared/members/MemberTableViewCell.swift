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
    
    func setup(membership: Membership) {
        textLbl.text = membership.user?.fullname
        
        membership.user?.setImage(imageV: self.imageV)
        
    }
    
}
