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
    
    @IBOutlet weak var titleImageV: UIImageView!
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
        
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        if (self.mode == .Edit && self.event == nil) {
            self.mode = .Create
        }
        
        self.startTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateEventViewController.handleTap(sender:)))
        self.endTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateEventViewController.handleTap(sender:)))
        
        self.titleTf.placeholder = L10n.eventName
        self.locationTf.placeholder = L10n.location
        
        self.configureFields()
        
        self.setImage(imageView: self.startImageV, icon: .fontAwesomeSolid(.clock))
        self.setImage(imageView: self.locationImageV, icon: .fontAwesomeSolid(.mapMarkerAlt))
        self.setImage(imageView: self.descriptionImageV, icon: .fontAwesomeSolid(.alignJustify))
        self.setImage(imageView: self.titleImageV, icon: .fontAwesomeSolid(.edit))
        
        self.setRightBarButton(type: .cancel)
        
        self.setupMode()
    }
    
    func setupMode() {
        
        var title = ""
        var createSaveBtnTitle = ""
        
        switch self.mode {
        case .Create:
            title = L10n.createEvent
            createSaveBtnTitle = L10n.createEvent
            self.deleteBtn.isHidden = true
            
            
            self.start = Date()
            self.end = Calendar.current.date(byAdding: .hour, value: 2, to: self.start!)
            self.updateDateTimeLabels()
            
            break
        case .Edit:
            title = L10n.updateEvent
            createSaveBtnTitle = L10n.updateEvent
            
            self.deleteBtn.isHidden = false
            
            self.editedTv = true
            self.titleTf.text = self.event!.name
            self.locationTf.text = self.event!.location?.name
            self.start = self.event!.start
            self.end = self.event!.end
            self.descriptionTv.text = self.event!.description
            self.updateDateTimeLabels()
            
            self.deleteBtn.tintColor = UIColor.coachPlusRedColor
            self.deleteBtn.setTitleForAllStates(title: L10n.deleteEvent)
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
        self.descriptionTv.text = L10n.description
        
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
            datePickerDialog.show(L10n.start, doneButtonTitle: L10n.done, cancelButtonTitle: L10n.cancel, defaultDate: date, minimumDate: nil, maximumDate: nil, datePickerMode: .dateAndTime, callback: {
                (date) -> Void in
                if let dt = date {
                    self.start = dt
                    
                    if (self.start!.isAfterDate(self.end!, granularity: .minute)) {
                        self.end = self.start
                    }
                    self.updateDateTimeLabels()
                }
            })
            break;
        case self.endTapRecognizer:
            if let d = self.end {
                date = d
            }
            datePickerDialog.show(L10n.end, doneButtonTitle: L10n.done, cancelButtonTitle: L10n.cancel, defaultDate: date, minimumDate: nil, maximumDate: nil, datePickerMode: .dateAndTime, callback: {
                (date) -> Void in
                if let dt = date {
                    self.end = dt
                    if (self.start!.isAfterDate(self.end!, granularity: .minute)) {
                        self.start = self.end
                    }
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
        
        self.loadData(text: L10n.loading, promise: DataHandler.def.createEvent(team: (self.membership?.team!)!, createEvent: createEvent)).done({response in
            self.dismiss(animated: true, completion: {
                self.delegate?.eventCreated()
            })
        }).catch({ err in
            print(err)
        })
        
    }
    
    func checkFields() -> Bool {
        
        guard self.titleTf.text != nil else {
            DropdownAlert.error(message: L10n.pleaseEnterAName)
            return false
        }
        
        guard self.locationTf.text != nil else {
            DropdownAlert.error(message: L10n.pleaseEnterALocation)
            return false
        }
        
        guard self.start != nil else {
            DropdownAlert.error(message: L10n.pleaseEnterAStartDate)
            return false
        }
        
        guard self.end != nil else {
            DropdownAlert.error(message: L10n.pleaseEnterAnEndDate)
            return false
        }
        
        guard self.start! < self.end! else {
            DropdownAlert.error(message: L10n.endDateMustBeAfterStartDate)
            return false
        }
        
        return true
    }
    
    func getEventFromFields() -> [String : Any] {
        let name = self.titleTf.text
        let location = self.locationTf.text
        let description = self.descriptionTv.text
        let start = self.start?.toTimestamp()
        let end = self.end?.toTimestamp()
        
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
        
        self.loadData(text: L10n.loading, promise: DataHandler.def.updateEvent(teamId: self.event!.teamId, eventId: self.event!.id, updateEvent: updateEvent)).done({response in
            self.dismiss(animated: true, completion: {
                EventManager.shared.eventsChanged.onNext(nil)
                self.delegate?.eventChanged(newEvent: response.toObject(Event.self, property: "event"))
            })
        }).catch({ err in
            print(err)
        })
        
    }
    
    
    func showDeleteConfirmation() {
        
        self.showConfirmation(title: L10n.deleteEvent, message: L10n.doYouReallyWantToDeleteThisEvent, yes: L10n.yes, no: L10n.no, yesStyle: .destructive, noStyle: .default, yesHandler: { action in
            self.loadData(text: L10n.loading, promise: DataHandler.def.deleteEvent(event: self.event!)).done({ apiResponse in
                self.dismiss(animated: true, completion: {
                    EventManager.shared.eventsChanged.onNext(nil)
                   self.delegate?.eventDeleted()
                })
            })
            
        }, noHandler: nil, style: .alert, showCancelButton: false)
        
        
    }
    
    
}
