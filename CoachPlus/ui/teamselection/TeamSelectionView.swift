//
//  TeamSelectionView.swift
//  CoachPlus
//
//  Created by Maurice Breit on 13.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import NibDesignable
import AlamofireImage

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
    }
    
    func setup(team:Team?) {
        
        self.name = "Unknown"
        
        if (team != nil) {
            self.nameLbl.text = team!.name
        }
        
        let url = URL(string: "https://s-media-cache-ak0.pinimg.com/originals/b5/79/5c/b5795ce445a43dd8c749b7cea29fb8de.jpg")!
        
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: self.imageV.frame.size,
            radius: self.imageV.frame.size.height / 2
        )
        
        self.imageV.af_setImage(withURL: url, placeholderImage: nil, filter: filter)
        
    }
    
    

}
