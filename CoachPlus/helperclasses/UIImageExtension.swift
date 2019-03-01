//
//  UIImageExtension.swift
//  CoachPlus
//
//  Created by Maurice Breit on 04.08.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    
    func toTeamImage() -> UIImage {
        let teamImageSize = CGSize(width: 500.0, height: 500.0)
        return self.af_imageScaled(to: teamImageSize)
    }
    
    func toUserImage() -> UIImage {
        let userImageSize = CGSize(width: 500.0, height: 500.0)
        return self.af_imageScaled(to: userImageSize)
    }
    
    func toBase64() -> String {
        let imageData:Data = self.jpegData(compressionQuality: 1.0)!
        let base64String = String.init(format: "%@%@", "data:image/jpeg;base64,", imageData.base64EncodedString())
        return base64String
    }
}
