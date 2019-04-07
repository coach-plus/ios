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

class CreateTeamViewController: CoachPlusViewController, ImageHelperDelegate, UITextFieldDelegate {
    
    enum Mode {
        case Create
        case Edit
    }

    @IBOutlet weak var headerView: TableHeaderView!
    @IBOutlet weak var nameTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var createBtn: OutlineButton!
    @IBOutlet weak var deleteBtn: OutlineButton!
    
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
    
    var mode = Mode.Create
    var team: Team?
    
    var membershipsController:MembershipsController?
    var selectedImage:UIImage?
    var imageHelper:ImageHelper?
    
    static let publicIconSize = CGSize(width: 20, height: 20)
    let privateIcon = UIImage.init(icon: .fontAwesomeSolid(.lock), size: CreateTeamViewController.publicIconSize, textColor: .coachPlusGrey, backgroundColor: .clear)
    
    @IBAction func selectImageTapped(_ sender: Any) {
        self.imageHelper?.showImagePicker()
    }
    
    @IBAction func createBtnTapped(_ sender: Any) {
        
        if (!self.validateTextField(textField: self.nameTf)) {
            return
        }

        let teamName = self.nameTf.text
        
        let isPublic = !self.publicSwitch.isOn
        
        var base64String = ""
        
        let size = CGSize(width: 500.0, height: 500.0)
        
        if (self.selectedImage != nil) {
            base64String = (self.selectedImage?.toTeamImage().toBase64())!
        }
        
        let team = [
            "name": teamName,
            "isPublic": isPublic,
            "image": base64String
            ] as [String : Any]
        
        if (self.mode == .Create) {
            self.loadData(text: "CREATE_TEAM", promise: DataHandler.def.createTeam(createTeam: team)).done({ membership in
                    FlowManager.selectAndOpenTeam(vc: self, teamId: membership.team?.id)
                    self.dismiss(animated: true, completion: nil)
                    MembershipManager.shared.loadMemberships()
                }).catch({ err in
                    print(err)
                })
        } else if (self.mode == .Edit) {
            self.loadData(text: "UPDATE_TEAM", promise: DataHandler.def.updateTeam(teamId: self.team!.id, updatedTeam: team)).done({ team in
                self.dismiss(animated: true, completion: nil)
                MembershipManager.shared.loadMemberships()
            }).catch({ err in
                print(err)
            })
        }
        
    }
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        
        self.showConfirmation(title: "DELETE_TEAM", message: "DELETE_TEAM_MESSAGE", yes: "DELETE_TEAM_YES", no: "CANCEL", yesStyle: .destructive, noStyle: .cancel, yesHandler: { _ in
            self.loadData(text: "DELETE_TEAM", promise: DataHandler.def.deleteTeam(teamId: self.team!.id)).done({ response in
                DropdownAlert.success(message: String(format: "DELETE_TEAM_SUCCESS".localize(), self.team!.name))
                FlowManager.selectAndOpenTeam(vc: self, teamId: nil)
            }).catch({ err in
                print(err)
            })
        }, noHandler: nil, style: .actionSheet, showCancelButton: false)
        
    }
    
    override func viewDidLoad() {
        
        
        self.imageV.isHidden = true
        
        self.setCoachPlusLogo()
        
        self.nameTf.coachPlus()
        self.nameTf.delegate = self
        
        let placeholder = UIImage.init(icon: .fontAwesomeSolid(.camera), size: CGSize(width: 50, height: 50), textColor: .white, backgroundColor: .clear)
        
        self.publicSwitch.onTintColor = .coachPlusBlue
        self.publicSwitch.isOn = false
        self.handlePublicSwitchState()
        
        self.publicImage.image = self.privateIcon
        
        self.cameraImageV.image = placeholder
        self.imageHelper = ImageHelper(vc: self)
        
        self.cameraContainer.backgroundColor = UIColor.coachPlusBlue
        
        if (self.mode == .Create) {
            self.setupCreateMode()
        } else if (self.mode == .Edit) {
            self.setupEditMode()
        }
        
        self.setRightBarButton(type: .cancel)
        
        super.viewDidLoad()
    }
    
    func setupCreateMode() {
        self.deleteBtn.isHidden = true
        
        self.headerView.title = "NEW_TEAM".localize()
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(CreateTeamViewController.selectImageTapped(_:)))
        cameraImageV.isUserInteractionEnabled = true
        cameraImageV.addGestureRecognizer(singleTap)
    }
    
    func setupEditMode() {
        self.createBtn.setTitleForAllStates(title: "SAVE_TEAM")
        
        self.deleteBtn.isHidden = false
        self.deleteBtn.tintColor = UIColor.coachPlusRedColor
        self.deleteBtn.setup()
        
        self.headerView.title = "EDIT_TEAM".localize()
        
        self.nameTf.text = self.team?.name
        self.publicSwitch.setOn(!self.team!.isPublic, animated: false)
        self.handlePublicSwitchState()
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(CreateTeamViewController.selectImageTapped(_:)))
        
        if (self.team?.image != nil) {
            self.imageV.setTeamImage(team: self.team, placeholderColor: UIColor.coachPlusBlue)
            self.cameraContainer.isHidden = true
            self.imageV.isHidden = false
            self.imageV.isUserInteractionEnabled = true
            self.imageV.addGestureRecognizer(singleTap)
        } else {
            cameraImageV.isUserInteractionEnabled = true
            cameraImageV.addGestureRecognizer(singleTap)
        }
        
        
        
        
        
        
    }
    
    func imageSelectedAndCropped(image: UIImage) {
        self.selectedImage = image
        self.imageV.image = self.selectedImage
        self.cameraContainer.isHidden = true
        self.imageV.isHidden = false
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(CreateTeamViewController.selectImageTapped(_:)))
        imageV.isUserInteractionEnabled = true
        imageV.addGestureRecognizer(singleTap)
        self.imageV.layer.cornerRadius = self.imageV.frame.size.width / 2
        self.imageV.clipsToBounds = true
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
