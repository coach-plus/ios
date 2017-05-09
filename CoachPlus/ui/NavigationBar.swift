//
//  NavigationBar.swift
//  CoachPlus
//
//  Created by Maurice Breit on 13.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import NibDesignable

class CoachPlusNavigationBar: UINavigationBar, NibDesignableProtocol {
    
    enum LeftBarButtonType:String {
        case none = "none"
        case back = "back"
        case done = "done"
        case teams = "team"
        case selectedTeam = "selectedTeam"
    }

    var team:Team?
    
    var teamSelectionV:TeamSelectionView?
    private var leftBarButtonType:LeftBarButtonType = .none
    
    @IBInspectable var leftBarButtonTypeString: String {
        get {
            return self.leftBarButtonType.rawValue
        }
        set(type) {
            if let typeEnum = LeftBarButtonType(rawValue: type) {
                self.leftBarButtonType = typeEnum
            } else {
                self.leftBarButtonType = .none
            }
            
            self.setLeftBarButton()
        }
    }
    
    func setLeftBarButtonType(type:LeftBarButtonType) {
        self.leftBarButtonTypeString = type.rawValue
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
        self.setLeftBarButton()
    }
    
    private func setLeftBarButton() {
        switch self.leftBarButtonType {
        case .back:
            self.setBackBarButton()
        case .done:
            self.setDoneBarButton()
        case .selectedTeam:
            self.setTeamSelectionBarButton()
        case .teams:
            self.setTeamsBarButton()
        default:
            break
        }
    }
    
    func setDoneBarButton() {
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done(sender:)))
        self.topItem?.setLeftBarButton(doneBtn, animated: true)
    }
    
    func setBackBarButton() {
        let backBtn = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back(sender:)))
        self.topItem?.setLeftBarButton(backBtn, animated: true)
    }
    
    func setTeamSelectionBarButton() {
        self.teamSelectionV = TeamSelectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 25))
        self.teamSelectionV?.setup(team: team)
        let bbi = UIBarButtonItem(title: "text", style: .plain, target: nil, action: nil)
        bbi.customView = self.teamSelectionV
        self.topItem?.setLeftBarButton(bbi, animated: true)
    }
    
    func setTeamsBarButton() {
        let teamsBtn = UIBarButtonItem(title: "Teams", style: .plain, target: self, action: #selector(openSlider(sender:)))
        self.topItem?.setLeftBarButton(teamsBtn, animated: true)
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
    
    
}
