//
//  NavigationBar.swift
//  CoachPlus
//
//  Created by Maurice Breit on 13.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation

class CoachPlusNavigationBar: UINavigationBar {
    
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.setBg()
        self.setTeamSelection(team: nil)
        self.setImage()
    }
    
    func setImage() {
        let img = UIImageView(image: UIImage(named: "LogoWhite"))
        img.contentMode = .scaleAspectFit
        
        let title = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 45))
        img.frame = title.bounds
        title.addSubview(img)
        self.topItem?.titleView = title
    }
    
    func setBg() {
        self.barTintColor = UIColor(hexString: "#3381b8")
    }
    
    func setTeamSelection(team: Team?) {
        
        let teamSelectionV = TeamSelectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 25))
        
        teamSelectionV.setup(team: team)
    
        let bbi = UIBarButtonItem(title: "text", style: .plain, target: nil, action: nil)
        bbi.customView = teamSelectionV
        
        self.topItem?.setLeftBarButton(bbi, animated: true)
        
    }
    
}
