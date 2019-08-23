//
//  ImageHelper.swift
//  CoachPlus
//
//  Created by Maurice Breit on 04.08.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit
import ImagePicker
import RSKImageCropper
import YPImagePicker

protocol ImageHelperDelegate {
    func imageSelectedAndCropped(image:UIImage)
}

class ImageHelper: NSObject, RSKImageCropViewControllerDelegate {

    var vc:UIViewController
    var delegate: ImageHelperDelegate
    
    init(vc:UIViewController) {
        self.vc = vc
        self.delegate = vc as! ImageHelperDelegate
    }
    
    func showImagePicker(vc: UIViewController) {
        var config = YPImagePickerConfiguration()
        
        config.library.maxNumberOfItems = 1
        config.screens = [.library, .photo]
        config.showsPhotoFilters = false
        config.preferredStatusBarStyle = .lightContent
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                var imageCropVC : RSKImageCropViewController!
                imageCropVC = RSKImageCropViewController(image: photo.image, cropMode: RSKImageCropMode.square)
                imageCropVC.delegate = self
                picker.dismiss(animated: true, completion: {
                    vc.present(imageCropVC, animated: true, completion: nil)
                })
            } else {
                picker.dismiss(animated: true, completion: nil)
            }
        }
        vc.present(picker, animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        self.delegate.imageSelectedAndCropped(image: croppedImage)
        controller.dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
