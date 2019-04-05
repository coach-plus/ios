//
//  UIImageViewExtension.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 10.05.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func setUserImage(user:User) {
        self.setUserImage(user: user, showPlaceholder: true)
    }
    
    func setTeamHeaderImage(team: Team?) {
        
        let width = UIApplication.shared.keyWindow?.frame.size.width ?? 500.0
        let placeholder = UIImage.init(icon: .ionicons(.tshirtOutline), size: CGSize(width: width, height: width), textColor: .coachPlusBlue, backgroundColor: .white)
        
        if (team != nil && team?.image != nil) {
            let fullUrl = team!.getTeamImageUrl()
            
            if let url = URL(string: fullUrl) {
                var kf = self.kf
                kf.indicatorType = .activity
            
                let options: KingfisherOptionsInfo = [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ]
                
                kf.setImage(
                    with: url,
                    placeholder: placeholder,
                    options: options)
                {
                    result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                        self.image = placeholder
                        print(placeholder.size)
                    }
                }
            } else {
                self.image = placeholder
                print(placeholder.size)
            }
        } else {
            self.image = placeholder
            print(placeholder.size)
        }
        
        
    }
    
    private func setRoundedImage(url: URL, placeHolder: UIImage?) {
                
        let processor = DownsamplingImageProcessor(size: self.frame.size)
        >> RoundCornerImageProcessor(cornerRadius: self.frame.size.height / 2, targetSize: self.frame.size, roundingCorners: RectCorner.all, backgroundColor: .clear)
        
        var kf = self.kf
        kf.indicatorType = .activity
        kf.setImage(
            with: url,
            placeholder: placeHolder,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                break
                //print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                break
                //print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
    func setUserImage(user:User, showPlaceholder:Bool) {
        var placeholder:UIImage? = nil
        
        if (showPlaceholder) {
            placeholder = UIImage.init(icon: .fontAwesomeSolid(.userCircle), size: self.frame.size, textColor: .coachPlusBlue, backgroundColor: .clear)
        }
        
        if user.image != nil {
            let fullUrl = user.getUserImageUrl()
            if let url = URL(string: fullUrl) {
                self.setRoundedImage(url: url, placeHolder: placeholder)
            }
        } else {
            self.image = placeholder
        }
    }
    
    func setTeamImage(team:Team?, placeholderColor:UIColor?) {

        var color = UIColor.coachPlusBlue
        
        if (placeholderColor != nil) {
            color = placeholderColor!
        }
        
        let placeholder = UIImage.init(icon: .fontAwesomeSolid(.users), size: self.frame.size, textColor: color, backgroundColor: .clear)
        
        if (team != nil && team?.image != nil) {
            let fullUrl = team?.getTeamImageUrl()
            if let url = URL(string: fullUrl!) {
                self.setRoundedImage(url: url, placeHolder: placeholder)
                //self.af_setImage(withURL: url, placeholderImage: placeholder, filter: filter)
            }
        } else {
            self.image = placeholder
        }
    }
    
}
