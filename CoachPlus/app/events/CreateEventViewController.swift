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

class CreateEventViewController: CoachPlusViewController, UITextViewDelegate {

    @IBOutlet weak var startL: UILabel!
    @IBOutlet weak var endL: UILabel!
    @IBOutlet weak var titleTf: UITextField!
    @IBOutlet weak var locationTf: UITextField!
    @IBOutlet weak var locationImageV: UIImageView!
    @IBOutlet weak var descriptionTv: UITextView!
    @IBOutlet weak var startImageV: UIImageView!
    @IBOutlet weak var descriptionImageV: UIImageView!
    
    var startTapRecognizer: UITapGestureRecognizer!
    var endTapRecognizer: UITapGestureRecognizer!
    
    var start: Date?
    var end: Date?
    
    var editedTv = false
    
    @IBAction func btnTap(_ sender: Any) {
        self.createEvent()
    }
    
    override func viewDidLoad() {
        
        self.title = "CREATE_EVENT".localize()
        
        self.startTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateEventViewController.handleTap(sender:)))
        self.endTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateEventViewController.handleTap(sender:)))
        
        self.titleTf.placeholder = "NAME".localize()
        self.locationTf.placeholder = "LOCATION".localize()
        
        self.configureFields()
        
        self.setImage(imageView: self.startImageV, icon: .fontAwesomeSolid(.clock))
        self.setImage(imageView: self.locationImageV, icon: .fontAwesomeSolid(.mapMarker))
        self.setImage(imageView: self.descriptionImageV, icon: .fontAwesomeSolid(.alignJustify))
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
        
        guard self.start != nil && self.end != nil else {
            DropdownAlert.error(message: "CREATE_EVENT_PLEASE_SELECT_START_AND_END")
            return
        }
        
        guard self.start! < self.end! else {
            DropdownAlert.error(message: "CREATE_EVENT_END_MUST_BE_AFTER_START")
            return
        }
        
        let name = self.titleTf.text
        let location = self.locationTf.text
        let description = self.descriptionTv.text
        let start = self.start?.toString()
        let end = self.end?.toString()
        
        guard name != nil || location != nil else {
            return
        }
        
        let createEvent = [
            "name": name,
            "location": [
                "name": location
            ],
            "start": start,
            "end": end
        ] as [String : Any]
        
        
        self.loadData(text: "CREATE_EVENT", promise: DataHandler.def.createEvent(team: (self.membership?.team!)!, createEvent: createEvent)).done({response in
            self.navigationController?.popViewController(animated: true)
        }).catch({ err in
            print(err)
        })
        
    }
    
    
    
}
