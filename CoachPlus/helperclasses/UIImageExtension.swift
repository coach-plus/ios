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
        return self.resizeImage(targetSize: teamImageSize)
    }
    
    func toUserImage() -> UIImage {
        let userImageSize = CGSize(width: 500.0, height: 500.0)
        return self.resizeImage(targetSize: userImageSize)
    }
    
    func toBase64() -> String {
        let imageData:Data = self.jpegData(compressionQuality: 1.0)!
        let base64String = String.init(format: "%@%@", "data:image/jpeg;base64,", imageData.base64EncodedString())
        return base64String
    }
    
    // credits go to https://stackoverflow.com/questions/31314412/how-to-resize-image-in-swift
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
