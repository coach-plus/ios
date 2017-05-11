//
//  TeamTableViewCell.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 29.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import AlamofireImage

class MembershipTableViewCell: UITableViewCell {

    @IBOutlet weak var leftLbl: UILabel!
    
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var imageV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setup(membership:Membership) {
        self.leftLbl.text = membership.team!.name
        
        if (membership.isCoach()) {
            self.editBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
            self.editBtn.setTitle(String.fontAwesomeIcon(name: .pencil), for: UIControlState.normal)
        } else {
            self.editBtn.setTitle("", for: UIControlState.normal)
        }
        
        self.imageV.setTeamImage(team: membership.team!, placeholderColor: nil)
    }
    
}
