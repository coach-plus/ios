//
//  TeamSelectionView.swift
//  CoachPlus
//
//  Created by Maurice Breit on 13.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import NibDesignable

class TeamSelectionView: NibDesignable {
    
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var imageV: UIImageView!
    
    @IBInspectable var image: UIImage {
        get {
            return self.imageV.image!
        }
        set(image) {
            self.imageV.image = image
        }
    }
    
    @IBInspectable var name: String {
        get {
            return self.nameLbl.text!
        }
        set(text) {
            self.nameLbl.text = text
        }
    }
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        self.initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSetup()
    }
    
    
    func initSetup() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(teamTapped(sender:)))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func teamTapped(sender:UIBarButtonItem) {
        
        FlowManager.openDrawer()
        /**
        let controller = UIApplication.shared.keyWindow?.rootViewController//UIApplication.topViewController(base: nil)
        
        
        if let navVc = controller as? CoachPlusNavigationViewController {
            FlowManager.openDrawer()
        } else if let navVc = controller as? CoachPlusViewController {
            navVc.slideMenuController()?.openLeft()
        } else if let navVc = controller as? HomeDrawerController {
            navVc.slideMenuController()?.openLeft()
        }**/
    }
    
    func setup(team:Team?) {
        
        self.name = "Unknown"
        
        if (team != nil) {
            self.nameLbl.text = team!.name
        }
        
        self.imageV.setTeamImage(team: team, placeholderColor: UIColor.white)
        
        
        
    }
    
    

}
