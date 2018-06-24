//
//  EditableTableViewCell.swift
//  CoachPlus
//
//  Created by Maurice Breit on 23.06.18.
//  Copyright © 2018 Mathandoro GbR. All rights reserved.
//

import UIKit

class EventDetailCell: UITableViewCell {
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var dateL: UILabel!
    
    @IBOutlet weak var locationL: UILabel!
    
    @IBOutlet weak var actionsB: UIButton!
    
    @IBOutlet weak var descriptionTv: UITextView!
    
    @IBAction func actionsButonTap(_ sender: Any) {
        guard self.isCoach && self.vc != nil else {
            return
        }
        
        self.showActions()
    }
    
    
    var event: Event?
    var isCoach = false
    var vc: UIViewController?

    func configure(event: Event, isCoach: Bool?, vc: UIViewController) {
        
        self.event = event
        self.isCoach = isCoach != nil && isCoach == true
        self.vc = vc
        
        guard self.event != nil else {
            return
        }
        
        self.nameL.text = self.event!.name
        self.dateL.text = self.event!.fromToString()
        self.locationL.text = self.event!.getLocationString()
        self.descriptionTv.text = self.event!.getDescriptionString()
        
        if (self.isCoach) {
            self.actionsB.setTitle("", for: .normal)
            self.actionsB.setCoachPlusIcon(fontType: .ionicons(.more), color: .coachPlusBlue)
            self.actionsB.isHidden = false

        } else {
            self.actionsB.isHidden = true
        }
        
        
    }
    
    func showActions() {
        let alertController = UIAlertController(title: "ACTIONS".localize(), message: "ACTIONS_WHAT_TO_DO".localize(), preferredStyle: .actionSheet)
        
        let sendButton = UIAlertAction(title: "EDIT".localize(), style: .default, handler: { (action) -> Void in
        })
        
        let deleteButton = UIAlertAction(title: "DELETE".localize(), style: .destructive, handler: { (action) -> Void in
            
        })
        
        let cancelButton = UIAlertAction(title: "CANCEL".localize(), style: .cancel, handler: { (action) -> Void in
            
        })
        
        
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.vc?.present(alertController, animated: true, completion: nil)
        
    }
    
    
}
