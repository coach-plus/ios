//
//  CoachPlusViewController.swift
//  CoachPlus
//
//  Created by Maurice Breit on 16.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit

class CoachPlusViewController: UIViewController {
    
    var team:Team?

    override func viewDidLoad() {
        self.setCoachPlusLogo()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    func pushToEventDetail(event:Event) {
        
        let targetVc = UIStoryboard(name: "EventDetail", bundle: nil).instantiateInitialViewController() as! EventDetailViewController
        targetVc.event = event
        
        self.navigationController?.pushViewController(targetVc, animated: true)
        
    }
    
}
