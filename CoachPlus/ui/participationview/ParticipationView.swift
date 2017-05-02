//
//  ParticipationView.swift
//  CoachPlus
//
//  Created by Maurice Breit on 17.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit

import NibDesignable

protocol ParticipationViewDelegate {
    func selected(yes:Bool)
}

class ParticipationView: NibDesignable {
    
    enum Mode {
        case didAttend
        case willAttend
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    var delegate: ParticipationViewDelegate?
    
    @IBOutlet weak var yesBtn: UIButton!
    
    @IBOutlet weak var noBtn: UIButton!
    
    var participation: Participation?
    var mode:Mode = .didAttend
    
    static let selectedYesColor = UIColor(hexString: "#73ba26")
    static let selectedNoColor = UIColor(hexString: "#FF3B30")
    static let unselectedColor = UIColor(hexString: "9b9b9b")
    
    @IBAction func yesTap(_ sender: Any) {
        delegate?.selected(yes: true)
    }
    
    @IBAction func noTap(_ sender: Any) {
        delegate?.selected(yes: false)
    }
    
    func setup() {
        self.yesBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        self.noBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        self.yesBtn.setTitle(String.fontAwesomeIcon(name: .check), for: .normal)
        self.noBtn.setTitle(String.fontAwesomeIcon(name: .times), for: .normal)
    }
    
    func getColor(bool:Bool, btn:UIButton) -> UIColor {
        if (!bool) {
            return ParticipationView.unselectedColor
        }
        if (btn == self.yesBtn) {
            return ParticipationView.selectedYesColor
        } else {
            return ParticipationView.selectedNoColor
        }
    }
    
    func setSelection(selection:Bool?) {
        
        var yes = false
        var no = false
        
        if (selection != nil) {
            yes = selection!
            no = !selection!
        }
        
        self.yesBtn.setTitleColor(self.getColor(bool: yes, btn: yesBtn), for: .normal)
        self.noBtn.setTitleColor(self.getColor(bool: no, btn: noBtn), for: .normal)
        
    }
    
    func configure(participation:Participation) {
        self.participation = participation
    
        if self.mode == .didAttend {
            self.setSelection(selection: self.participation?.didAttend)
        } else {
            self.setSelection(selection: self.participation?.willAttend)
        }
        
        self.isHidden = false
        
    }
}
