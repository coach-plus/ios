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
import SkyFloatingLabelTextField
import MBProgressHUD

class CreateTeamViewController: CoachPlusViewController, ImageHelperDelegate, UITextFieldDelegate {

    @IBOutlet weak var headerView: TableHeaderView!
    @IBOutlet weak var nameTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var createBtn: OutlineButton!
    
    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var cameraImageV: UIImageView!
    
    @IBOutlet weak var cameraContainer: UIView!
    
    @IBOutlet weak var publicImage: UIImageView!
    
    @IBOutlet weak var publicSwitch: UISwitch!
    
    @IBOutlet weak var publicTitle: UILabel!
    
    @IBOutlet weak var publicDescription: UILabel!
    
    @IBAction func onPublicChange(_ sender: Any) {
        self.handlePublicSwitchState()
    }
    
    var membershipsController:MembershipsController?
    var selectedImage:UIImage?
    var imageHelper:ImageHelper?
    
    static let publicIconSize = CGSize(width: 20, height: 20)
    let privateIcon = UIImage.init(icon: .fontAwesome(.lock), size: CreateTeamViewController.publicIconSize, textColor: .coachPlusGrey, backgroundColor: .clear)
    
    @IBAction func selectImageTapped(_ sender: Any) {
        self.imageHelper?.showImagePicker()
    }
    
    @IBAction func createBtnTapped(_ sender: Any) {
        
        if (!self.validateTextField(textField: self.nameTf)) {
            return
        }

        let teamName = self.nameTf.text
        
        let isPublic = true
        
        var base64String = ""
        
        let size = CGSize(width: 500.0, height: 500.0)
        
        if (self.selectedImage != nil) {
            base64String = (self.selectedImage?.toTeamImage().toBase64())!
        }
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.detailsLabel.text = "Erstelle Team"
        
        _ = DataHandler.def.createTeam(createTeam: [
            "name": teamName,
            "isPublic": isPublic,
            "image": base64String
            ], successHandler: { membership in
                if (self.membershipsController != nil) {
                    self.membershipsController?.teamIdToBeSelected = membership.id
                    self.membershipsController?.loadTeams()
                }
                hud.hide(animated: true)
                self.dismiss(animated: true, completion: nil)
        }, failHandler: { err in
            print(err.message)
            hud.hide(animated: true)
        })
    }
    
    override func viewDidLoad() {
        self.imageV.isHidden = true
        
        self.setCoachPlusLogo()
        
        self.headerView.title = "NEW_TEAM".localize()
        self.nameTf.coachPlus()
        self.nameTf.delegate = self
        
        let placeholder = UIImage.init(icon: .fontAwesome(.camera), size: CGSize(width: 50, height: 50), textColor: .white, backgroundColor: .clear)
        
        self.publicSwitch.onTintColor = .coachPlusBlue
        self.publicSwitch.isOn = false
        self.handlePublicSwitchState()
        
        self.publicImage.image = self.privateIcon
        
        self.cameraImageV.image = placeholder
        self.imageHelper = ImageHelper(vc: self)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(CreateTeamViewController.selectImageTapped(_:)))
        cameraImageV.isUserInteractionEnabled = true
        cameraImageV.addGestureRecognizer(singleTap)
        
        self.cameraContainer.backgroundColor = UIColor.coachPlusBlue
        
        super.viewDidLoad()

    }
    
    func imageSelectedAndCropped(image: UIImage) {
        self.selectedImage = image
        self.imageV.setTeamImage(image: image)
        self.cameraContainer.isHidden = true
        self.imageV.isHidden = false
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(CreateTeamViewController.selectImageTapped(_:)))
        imageV.isUserInteractionEnabled = true
        imageV.addGestureRecognizer(singleTap)
    }
    
    
    func handlePublicSwitchState() {
        if (self.publicSwitch.isOn) {
            self.publicDescription.text = "CREATE_TEAM_MESSAGE_TEAM_PRIVATE".localize()
        } else {
            self.publicDescription.text = "CREATE_TEAM_MESSAGE_TEAM_PUBLIC".localize()
        }
    }
    
    func validateTextField(textField: UITextField) -> Bool {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if (text.count == 0) {
                    floatingLabelTextField.errorMessage = "Bitte gib einen Namen ein"
                    return false
                } else if(text.count < 3) {
                    floatingLabelTextField.errorMessage = "Der Name muss mindestens 3 Zeichen lang sein"
                    return false
                }
                else {
                    floatingLabelTextField.errorMessage = ""
                    return true
                }
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            if (text.count > 0 || string.count > 0) {
                if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        _ = validateTextField(textField: textField)
    }
}
