//
//  CreateTeamViewController.swift
//  CoachPlus
//
//  Created by Maurice Breit on 08.05.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import ImagePicker

class CreateTeamViewController: CoachPlusViewController, ImagePickerDelegate {

    @IBOutlet weak var nameTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var createBtn: OutlineButton!
    
    
    var selectedImage:UIImage?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectImageTapped(_ sender: Any) {
        
        var config = Configuration()
        config.doneButtonTitle = "Finish"
        config.noImagesTitle = "Sorry! There are no images here!"
        config.recordLocation = false
        
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.configuration = config
        imagePickerController.imageLimit = 1
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func createBtnTapped(_ sender: Any) {
        
        let teamName = self.nameTf.text
        
        let isPublic = true
        
        var base64String = ""
        
        if (self.selectedImage != nil) {
            let imageData:Data =  UIImagePNGRepresentation(self.selectedImage!)!
            base64String = String.init(format: "%@%@", "data:image/jpeg;base64,", imageData.base64EncodedString())
        }
        
        
        DataHandler.def.createTeam(createTeam: [
            "name": teamName,
            "isPublic": isPublic,
            "image": base64String
            ], successHandler: { response in
                self.dismiss(animated: true, completion: nil)
        }, failHandler: { err in
            print(err.message)
        })
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
            self.selectedImage = images[0]
        }
        
    }

}
