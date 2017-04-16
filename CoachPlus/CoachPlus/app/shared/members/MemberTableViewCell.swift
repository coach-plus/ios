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
        
        let urlString = "https://pbs.twimg.com/profile_images/775833954314285057/FIxA8Vcq1.jpg"
        
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: self.imageV.frame.size,
            radius: self.imageV.frame.size.height / 2
        )
        
        let url = URL(string: urlString)!
        
        let placeholder = UIImage.fontAwesomeIcon(name: .userCircleO, textColor: UIColor.coachPlusBlue, size: self.imageV.frame.size)
        
        self.imageV.af_setImage(withURL: url, placeholderImage: placeholder, filter: filter)
        
    }
    
}
