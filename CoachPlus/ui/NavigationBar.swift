//
//  NavigationBar.swift
//  CoachPlus
//
//  Created by Maurice Breit on 13.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation

class CoachPlusNavigationBar: UINavigationBar {
    
    
    var teamSelectionV:TeamSelectionView?
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.setStyling()
        self.setTeamSelection(team: nil)
    }
    
    func setStyling() {
        self.barTintColor = UIColor(hexString: "#3381b8")
        self.tintColor = UIColor.white
    }
    
    func setTeamSelection(team: Team?) {
        
        self.teamSelectionV = TeamSelectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 25))
        
        self.teamSelectionV?.setup(team: team)
    
        let bbi = UIBarButtonItem(title: "text", style: .plain, target: nil, action: nil)
        bbi.customView = self.teamSelectionV
        
        self.topItem?.setLeftBarButton(bbi, animated: true)
        
        
        
    }
    
    
}
