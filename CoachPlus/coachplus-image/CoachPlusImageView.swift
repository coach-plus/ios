//
//  CoachPlusImageView.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 01.03.19.
//  Copyright © 2019 Mathandoro GbR. All rights reserved.
//

import UIKit
import SwiftIcons
import NibDesignable

class CoachPlusImageView: NibDesignable {

    @IBOutlet public weak var imageView: UIImageView!
    @IBOutlet public weak var detailImageView: UIImageView!
    @IBOutlet weak var detailContainerView: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func draw(_ rect: CGRect) {
        detailContainerView.layer.cornerRadius = self.detailContainerView.bounds.size.width/2
        self.setup()
        super.draw(rect)
    }
    
    func setup() {
        
        detailContainerView.clipsToBounds = true
        detailContainerView.backgroundColor = .white
        
        /*
        detailContainerView.layer.borderColor = UIColor.coachPlusBlue.cgColor
        detailContainerView.layer.borderWidth = 1.0
         */
    }
    
    public func setIsCoach(isCoach: Bool) {
        self.setup()
        if (isCoach) {
            self.detailImageView.image = UIImage(named: "CoachLogo")
            self.detailContainerView.isHidden = false
        } else {
            self.detailContainerView.isHidden = true
        }
    }
    
    public func setIsPrivate(isPrivate: Bool) {
        self.setup()
        if (isPrivate) {
            self.detailImageView.setIcon(icon: .fontAwesomeSolid(.lock), textColor: .coachPlusBlue, backgroundColor: .white, size: self.detailImageView.frame.size)
            self.detailContainerView.isHidden = false
        } else {
            self.detailContainerView.isHidden = true
        }
    }

}
