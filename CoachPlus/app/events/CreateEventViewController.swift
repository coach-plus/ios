//
//  CreateEventViewController.swift
//  CoachPlus
//
//  Created by Maurice Breit on 17.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class CreateEventViewController: CoachPlusViewController {

    @IBOutlet weak var titleTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var locationTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var startPicker: UIDatePicker!
    
    @IBOutlet weak var endPicker: UIDatePicker!
    
    @IBAction func btnTap(_ sender: Any) {
        self.createEvent()
    }
    
    func createEvent() {
        
        let name = self.titleTf.text
        let location = self.locationTf.text
        let start = self.startPicker.date
        let end = self.endPicker.date
        
        guard name != nil || location != nil else {
            return
        }
        
        let createEvent = [
            "name": name,
            "location": location,
            "start": start.toString(),
            "end": end.toString()
        ]
        
        DataHandler.def.createEvent(team: self.team!, createEvent: createEvent, successHandler: { response in
            self.navigationController?.popViewController(animated: true)
        }, failHandler: { error in
            print(error)
        })
        
    }
    
    
    
}
