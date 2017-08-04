//
//  CreateTeamViewController.swift
//  CoachPlus
//
//  Created by Maurice Breit on 08.05.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftIcons

class CreateTeamViewController: CoachPlusViewController, ImageHelperDelegate {

    @IBOutlet weak var nameTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var createBtn: OutlineButton!
    
    @IBOutlet weak var imageV: UIImageView!
    
    var membershipsController:MembershipsController?
    
    var selectedImage:UIImage?
    
    var imageHelper:ImageHelper?
    
    @IBAction func selectImageTapped(_ sender: Any) {
        self.imageHelper?.showImagePicker()
    }
    
    @IBAction func createBtnTapped(_ sender: Any) {

        let teamName = self.nameTf.text
        
        let isPublic = true
        
        var base64String = ""
        
        let size = CGSize(width: 500.0, height: 500.0)
        
        if (self.selectedImage != nil) {
            base64String = (self.selectedImage?.toTeamImage().toBase64())!
        }
        
        _ = DataHandler.def.createTeam(createTeam: [
            "name": teamName,
            "isPublic": isPublic,
            "image": base64String
            ], successHandler: { membership in
                if (self.membershipsController != nil) {
                    self.membershipsController?.teamIdToBeSelected = membership.id
                    self.membershipsController?.loadTeams()
                }
                self.dismiss(animated: true, completion: nil)
        }, failHandler: { err in
            print(err.message)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let placeholder = UIImage.init(icon: .ionicons(.tshirtOutline), size: CGSize(width: 100, height: 100), textColor: .coachPlusBlue, backgroundColor: .white)
        self.imageV.image = placeholder
        self.imageHelper = ImageHelper(vc: self)
    }
    
    func imageSelectedAndCropped(image: UIImage) {
        self.selectedImage = image
        self.imageV.setTeamImage(image: image)
    }

}
