//
//  UIImageViewExtension.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 10.05.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

extension UIImageView {
    func setUserImage(user:User) {
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: self.frame.size,
            radius: self.frame.size.height / 2
        )
        
        let placeholder = UIImage.fontAwesomeIcon(name: .userCircleO, textColor: UIColor.coachPlusBlue, size: self.frame.size)
        
        if user.image != nil {
            let fullUrl = user.getUserImageUrl()
            if let url = URL(string: fullUrl) {
                self.af_setImage(withURL: url, placeholderImage: placeholder, filter: filter)
            }
        } else {
            self.image = placeholder
        }
    }
    
    func setTeamImage(image:UIImage) {
        self.image = image.af_imageRoundedIntoCircle()
    }
    
    func getFilter() -> AspectScaledToFillSizeWithRoundedCornersFilter{
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: self.frame.size,
            radius: self.frame.size.height / 2
        )
        return filter
    }
    
    func setTeamImage(team:Team?, placeholderColor:UIColor?) {
        
        var filter = self.getFilter()
        var color = UIColor.coachPlusBlue
        
        if (placeholderColor != nil) {
            color = placeholderColor!
        }
        
        let placeholder = UIImage.fontAwesomeIcon(name: .users, textColor: color, size: self.frame.size)
        
        if (team != nil && team?.image != nil) {
            let fullUrl = team?.getTeamImageUrl()
            if let url = URL(string: fullUrl!) {
                self.af_setImage(withURL: url, placeholderImage: placeholder, filter: filter)
            }
        } else {
            self.image = placeholder
        }
    }
    
}
