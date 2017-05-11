//
//  NavigationBar.swift
//  CoachPlus
//
//  Created by Maurice Breit on 13.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import NibDesignable

protocol CoachPlusNavigationBarDelegate {
    func profile(sender:UIBarButtonItem)
}

class CoachPlusNavigationBar: UINavigationBar, NibDesignableProtocol {
    
    enum BarButtonType:String {
        case none = "none"
        case back = "back"
        case done = "done"
        case teams = "team"
        case selectedTeam = "selectedTeam"
        case profile = "profile"
    }

    var team:Team?
    
    var teamSelectionV:TeamSelectionView?
    
    var coachPlusNavigationBarDelegate:CoachPlusNavigationBarDelegate?
    
    private var leftBarButtonType:BarButtonType = .none
    
    @IBInspectable var leftBarButtonTypeString: String {
        get {
            return self.leftBarButtonType.rawValue
        }
        set(type) {
            if let typeEnum = BarButtonType(rawValue: type) {
                self.leftBarButtonType = typeEnum
            } else {
                self.leftBarButtonType = .none
            }
            
            self.setLeftBarButton()
        }
    }
    
    func setLeftBarButtonType(type:BarButtonType) {
        self.leftBarButtonTypeString = type.rawValue
    }
    
    
    private var rightBarButtonType:BarButtonType = .none
    
    @IBInspectable var rightBarButtonTypeString: String {
        get {
            return self.rightBarButtonType.rawValue
        }
        set(type) {
            if let typeEnum = BarButtonType(rawValue: type) {
                self.rightBarButtonType = typeEnum
            } else {
                self.rightBarButtonType = .none
            }
            
            self.setRightBarButton()
        }
    }
    
    func setRightBarButtonType(type:BarButtonType) {
        self.rightBarButtonTypeString = type.rawValue
    }
    
    
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.setStyling()
    }
    
    private func createBarButton(type:BarButtonType) -> UIBarButtonItem? {
        var btn:UIBarButtonItem?
        switch type {
            case .back:
                btn = self.createDoneBarButton()
            case .done:
                btn = self.createDoneBarButton()
            case .selectedTeam:
                btn = self.createTeamSelectionBarButton()
            case .teams:
                btn = self.createTeamsBarButton()
            case .profile:
                btn = self.createProfileBarButton()
            default:
                break
        }
        return btn
    }
    
    private func setRightBarButton() {
        let btn = self.createBarButton(type: self.rightBarButtonType)
        guard btn != nil else {
            return
        }
        self.topItem?.setRightBarButton(btn, animated: true)
    }
    
    private func setLeftBarButton() {
        let btn = self.createBarButton(type: self.leftBarButtonType)
        guard btn != nil else {
            return
        }
        self.topItem?.setLeftBarButton(btn, animated: true)
    }
    
    func createDoneBarButton() -> UIBarButtonItem {
        return UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done(sender:)))
    }
    
    func createProfileBarButton() -> UIBarButtonItem {
        let btn = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(profile(sender:)))
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
        btn.setTitleTextAttributes(attributes, for: .normal)
        btn.title = String.fontAwesomeIcon(name: .user)
        return btn
    }
    
    func createBackBarButton() -> UIBarButtonItem {
        return UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back(sender:)))
    }
    
    func createTeamSelectionBarButton() -> UIBarButtonItem {
        self.teamSelectionV = TeamSelectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 25))
        self.teamSelectionV?.setup(team: team)
        let bbi = UIBarButtonItem(title: "text", style: .plain, target: nil, action: nil)
        bbi.customView = self.teamSelectionV
        return bbi
    }
    
    func createTeamsBarButton() -> UIBarButtonItem {
        return UIBarButtonItem(title: "Teams", style: .plain, target: self, action: #selector(openSlider(sender:)))
    }
    
    func setStyling() {
        self.barTintColor = UIColor(hexString: "#3381b8")
        self.tintColor = UIColor.white
    }
    
    func setTeamSelection(team: Team?) {
        self.team = team
        self.setLeftBarButtonType(type: .selectedTeam)
    }
    
    func openSlider(sender:UIBarButtonItem) {
        let controller = UIApplication.shared.keyWindow?.rootViewController
        controller?.openLeft()
    }
    
    func done(sender:UIBarButtonItem) {
        let controller = UIApplication.shared.keyWindow?.rootViewController
        controller?.dismiss(animated: true, completion: nil)
    }
    
    func back(sender:UIBarButtonItem) {
        let controller = UIApplication.shared.keyWindow?.rootViewController
        controller?.navigationController?.popViewController(animated: true)
    }
    
    func profile(sender:UIBarButtonItem) {
        self.coachPlusNavigationBarDelegate?.profile(sender: sender)
    }
    
    
}
