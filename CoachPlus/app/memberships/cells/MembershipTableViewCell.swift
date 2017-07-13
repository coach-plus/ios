//
//  TeamTableViewCell.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 29.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import AlamofireImage
import FontAwesome_swift

class MembershipTableViewCell: UITableViewCell {

    @IBOutlet weak var leftLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var privateIndicatorLbl: UILabel!
    
    
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
        
        self.descriptionLbl.text = "keine Beschreibung"
        
        /*
        if (membership.isCoach()) {
            self.editBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
            self.editBtn.setTitle(String.fontAwesomeIcon(name: .pencil), for: UIControlState.normal)
        } else {
            self.editBtn.setTitle("", for: UIControlState.normal)
        }*/
        
        if (membership.team?.isPublic)! {
            self.privateIndicatorLbl.text = ""
        } else {
            self.privateIndicatorLbl.font = UIFont.fontAwesome(ofSize: 15)
            self.privateIndicatorLbl.text = String.fontAwesomeIcon(name: .lock)
        }
        
        self.imageV.setTeamImage(team: membership.team!, placeholderColor: nil)
    }
    
}
