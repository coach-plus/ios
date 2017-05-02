//
//  UIViewControllerExtension.swift
//  CoachPlus
//
//  Created by Maurice Breit on 16.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setCoachPlusLogo() {
        let topItem = self.navigationItem
        let img = UIImageView(image: UIImage(named: "LogoWhite"))
        img.contentMode = .scaleAspectFit
        
        let title = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 45))
        img.frame = title.bounds
        title.addSubview(img)
        topItem.titleView = title
    }
    
}
