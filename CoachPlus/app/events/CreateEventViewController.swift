//
//  CreateEventViewController.swift
//  CoachPlus
//
//  Created by Maurice Breit on 17.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftIcons
import SwiftDate


protocol CreateEventViewControllerDelegate {
    func eventCreated()
    func eventChanged(newEvent: Event)
    func eventDeleted()
}

class CreateEventViewController: CoachPlusViewController, UITextViewDelegate {

    
    public enum Mode{
        case Create
        case Edit
    }
    
    @IBOutlet weak var startL: UILabel!
    @IBOutlet weak var endL: UILabel!
    @IBOutlet weak var titleTf: UITextField!
    @IBOutlet weak var locationTf: UITextField!
    @IBOutlet weak var locationImageV: UIImageView!
    @IBOutlet weak var descriptionTv: UITextView!
    @IBOutlet weak var startImageV: UIImageView!
    @IBOutlet weak var descriptionImageV: UIImageView!
    
    @IBOutlet weak var createSaveBtn: OutlineButton!
    @IBOutlet weak var deleteBtn: OutlineButton!
    
    
    var startTapRecognizer: UITapGestureRecognizer!
    var endTapRecognizer: UITapGestureRecognizer!
    
    var start: Date?
    var end: Date?
    
    var editedTv = false
    
    var mode: Mode = .Create
    var event: Event?
    
    var delegate: CreateEventViewControllerDelegate?
    
    @IBAction func btnTap(_ sender: Any) {
        switch self.mode {
        case .Create:
            self.createEvent()
            break
        case .Edit:
            self.updateEvent()
            break
        default:
            break
        }
    }
    
    @IBAction func deleteBtnTap(_ sender: Any) {
        self.showDeleteConfirmation()
    }
    
    override func viewDidLoad() {
        
        if (self.mode == .Edit && self.event == nil) {
            self.mode = .Create
        }
        
        self.startTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateEventViewController.handleTap(sender:)))
        self.endTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateEventViewController.handleTap(sender:)))
        
        self.titleTf.placeholder = "NAME".localize()
        self.locationTf.placeholder = "LOCATION".localize()
        
        self.configureFields()
        
        self.setImage(imageView: self.startImageV, icon: .fontAwesomeSolid(.clock))
        self.setImage(imageView: self.locationImageV, icon: .fontAwesomeSolid(.mapMarker))
        self.setImage(imageView: self.descriptionImageV, icon: .fontAwesomeSolid(.alignJustify))
        
        self.setRightBarButton(type: .cancel)
        
        self.setupMode()
    }
    
    func setupMode() {
        
        var title = ""
        var createSaveBtnTitle = ""
        
        switch self.mode {
        case .Create:
            title = "CREATE_EVENT"
            createSaveBtnTitle = "CREATE_EVENT"
            self.deleteBtn.isHidden = true
            break
        case .Edit:
            title = "UPDATE_EVENT"
            createSaveBtnTitle = "UPDATE_EVENT"
            
            self.deleteBtn.isHidden = false
            
            self.editedTv = true
            self.titleTf.text = self.event!.name
            self.locationTf.text = self.event!.location?.name
            self.start = self.event!.start
            self.end = self.event!.end
            self.descriptionTv.text = self.event!.description
            self.updateDateTimeLabels()
            
            self.deleteBtn.tintColor = UIColor.coachPlusRedColor
            self.deleteBtn.setup()
            
            break
        default:
            break
        }
        
        self.title = title.localize()
        self.createSaveBtn.setTitleForAllStates(title: createSaveBtnTitle)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (editedTv == false) {
            editedTv = true
            textView.text = ""
        }
        textView.font = self.titleTf.font
        textView.textColor = self.titleTf.textColor
    }
    
    func configureFields() {
        let font = self.titleTf.font
        self.startL.font = font
        self.endL.font = font
        self.locationTf.font = font
        self.descriptionTv.font = font
        
        let textColor = UIColor.coachPlusBlue
        self.titleTf.textColor = textColor
        self.locationTf.textColor = textColor
        self.descriptionTv.textColor = textColor
        
        self.startL.textColor = textColor
        self.endL.textColor = textColor
        
        startL.isUserInteractionEnabled = true
        startL.addGestureRecognizer(self.startTapRecognizer)
        
        endL.isUserInteractionEnabled = true
        endL.addGestureRecognizer(self.endTapRecognizer)
        
        self.descriptionTv.textColor = UIColor(hexString: "#C7C7CD")
        self.descriptionTv.font = UIFont.systemFont(ofSize: 16)//UIFont(name: "HelveticaNeue-Medium", size: 16)
        self.descriptionTv.text = "DESCRIPTION".localize()
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
    }
    
    @objc func handleTap(sender:UITapGestureRecognizer) {
        
        let datePickerDialog = DatePickerDialog(textColor: UIColor.black, buttonColor: UIColor.coachPlusBlue, font: .boldSystemFont(ofSize: 15), locale: nil, showCancelButton: true)
        var date = Date()
        
        switch sender {
        case self.startTapRecognizer:
            if let d = self.start {
                date = d
            }
            datePickerDialog.show("START_DATE".localize(), doneButtonTitle: "DONE".localize(), cancelButtonTitle: "CANCEL".localize(), defaultDate: date, minimumDate: nil, maximumDate: nil, datePickerMode: .dateAndTime, callback: {
                (date) -> Void in
                if let dt = date {
                    self.start = dt
                    self.updateDateTimeLabels()
                }
            })
            break;
        case self.endTapRecognizer:
            if let d = self.end {
                date = d
            }
            datePickerDialog.show("END_DATE".localize(), doneButtonTitle: "DONE".localize(), cancelButtonTitle: "CANCEL".localize(), defaultDate: date, minimumDate: nil, maximumDate: nil, datePickerMode: .dateAndTime, callback: {
                (date) -> Void in
                if let dt = date {
                    self.end = dt
                    self.updateDateTimeLabels()
                }
            })
            break;
        default:
            break;
        }
    }
    
    func setImage(imageView: UIImageView, icon: FontType) {
        let size = imageView.frame.size.width * 0.6
        imageView.setIcon(icon: icon, textColor: UIColor.coachPlusBlue, backgroundColor: UIColor.clear, size: CGSize(width: size, height: size))
    }
    
    func updateDateTimeLabels() {
        if let dt = self.start {
            self.startL.text = dt.simpleFormatted()
        }
        if let dt = self.end {
            self.endL.text = dt.simpleFormatted()
        }
    }
    
    func createEvent() {
        
        guard self.checkFields() else {
            return
        }

        let createEvent = self.getEventFromFields()
        
        self.loadData(text: "CREATE_EVENT", promise: DataHandler.def.createEvent(team: (self.membership?.team!)!, createEvent: createEvent)).done({response in
            self.dismiss(animated: true, completion: {
                self.delegate?.eventCreated()
            })
        }).catch({ err in
            print(err)
        })
        
    }
    
    func checkFields() -> Bool {
        
        guard self.titleTf.text != nil else {
            DropdownAlert.error(message: "CREATE_EVENT_PLEASE_ENTER_NAME")
            return false
        }
        
        guard self.locationTf.text != nil else {
            DropdownAlert.error(message: "CREATE_EVENT_PLEASE_ENTER_LOCATION")
            return false
        }
        
        guard self.start != nil && self.end != nil else {
            DropdownAlert.error(message: "CREATE_EVENT_PLEASE_SELECT_START_AND_END")
            return false
        }
        
        guard self.start! < self.end! else {
            DropdownAlert.error(message: "CREATE_EVENT_END_MUST_BE_AFTER_START")
            return false
        }
        
        return true
    }
    
    func getEventFromFields() -> [String : Any] {
        let name = self.titleTf.text
        let location = self.locationTf.text
        let description = self.descriptionTv.text
        let start = self.start?.toString()
        let end = self.end?.toString()
        
        let createEvent = [
            "name": name,
            "location": [
                "name": location
            ],
            "start": start,
            "end": end,
            "description": description ?? ""
            ] as [String : Any]
        
        return createEvent
    }
    
    func updateEvent() {
        
        guard self.checkFields() else {
            return
        }
        
        let updateEvent = self.getEventFromFields()
        
        self.loadData(text: "UPDATE_EVENT", promise: DataHandler.def.updateEvent(teamId: self.event!.teamId, eventId: self.event!.id, updateEvent: updateEvent)).done({response in
            self.dismiss(animated: true, completion: {
                self.delegate?.eventChanged(newEvent: response.toObject(Event.self, property: "event"))
            })
        }).catch({ err in
            print(err)
        })
        
    }
    
    
    func showDeleteConfirmation() {
        
        self.showConfirmation(title: "DELETE_EVENT", message: "DELETE_EVENT_CONFIRMATION", yes: "YES", no: "NO", yesStyle: .destructive, noStyle: .default, yesHandler: { action in
            self.loadData(text: "DELETE_EVENT", promise: DataHandler.def.deleteEvent(event: self.event!)).done({ apiResponse in
                self.dismiss(animated: true, completion: {
                   self.delegate?.eventDeleted()
                })
            })
            
        }, noHandler: nil, style: .alert)
        
        
    }
    
    
}
