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
        
        let url = URL(string: "https://s-media-cache-ak0.pinimg.com/originals/b5/79/5c/b5795ce445a43dd8c749b7cea29fb8de.jpg")!
        
        self.imageV.af_setImage(withURL: url)
    }
    
}
