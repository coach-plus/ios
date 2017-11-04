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

protocol ImageHelperDelegate {
    func imageSelectedAndCropped(image:UIImage)
}

class ImageHelper: NSObject, ImagePickerDelegate, RSKImageCropViewControllerDelegate {
    
    var vc:UIViewController
    var delegate: ImageHelperDelegate
    
    init(vc:UIViewController) {
        self.vc = vc
        self.delegate = vc as! ImageHelperDelegate
    }
    
    func showImagePicker() {
        var config = Configuration()
        config.doneButtonTitle = "Finish"
        config.noImagesTitle = "Sorry! There are no images here!"
        config.recordLocation = false
        
        let imagePickerController = ImagePickerController.init(configuration: config)
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        vc.present(imagePickerController, animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        //guard images.count > 0 else { return }
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        if (images.count > 0) {
            let selectedImage = images[0]
            var imageCropVC : RSKImageCropViewController!
            imageCropVC = RSKImageCropViewController(image: selectedImage, cropMode: RSKImageCropMode.square)
            imageCropVC.delegate = self
            vc.present(imageCropVC, animated: true, completion: nil)
        }
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        self.delegate.imageSelectedAndCropped(image: croppedImage)
        controller.dismiss(animated: true, completion: nil)
    }
}
