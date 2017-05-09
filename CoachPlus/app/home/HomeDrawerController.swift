//
//  HomeDrawerController.swift
//  CoachPlus
//
//  Created by Maurice Breit on 08.05.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import SlideMenuControllerSwift

class HomeDrawerController: SlideMenuController {
    
    override func awakeFromNib() {
        
        let membershipsStoryboard = UIStoryboard(name: "Memberships", bundle: nil)
        self.leftViewController = membershipsStoryboard.instantiateInitialViewController()
        
        let teamStoryboard = UIStoryboard(name: "Team", bundle: nil)
        self.mainViewController = teamStoryboard.instantiateInitialViewController()
        
        super.awakeFromNib()
    }
    
}
