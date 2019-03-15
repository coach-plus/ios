//
//  EditableTableViewCell.swift
//  CoachPlus
//
//  Created by Maurice Breit on 23.06.18.
//  Copyright © 2018 Mathandoro GbR. All rights reserved.
//

import UIKit

protocol EventDetailCellActions {
    func delete(event: Event)
}

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
    var team: Team?
    var isCoach = false
    var vc: UIViewController?

    func configure(event: Event, team: Team, isCoach: Bool?, vc: UIViewController?) {
        
        self.event = event
        self.team = team
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
        
        let editButton = UIAlertAction(title: "EDIT".localize(), style: .default, handler: { (action) -> Void in
            
            let editEventVc = FlowManager.createEditEventVc(mode: .Edit, membership: MembershipManager.shared.selectedMembership, event: self.event, delegate: self.vc as? CreateEventViewControllerDelegate)
            
            self.vc?.present(editEventVc, animated: true, completion: nil)
        })
        
        let cancelButton = UIAlertAction(title: "CANCEL".localize(), style: .cancel, handler: { (action) -> Void in
            
        })
        
        alertController.addAction(editButton)
        alertController.addAction(cancelButton)
        
        self.vc?.present(alertController, animated: true, completion: nil)
        
    }
    
    
}
