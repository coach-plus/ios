//
//  NavigationBar.swift
//  CoachPlus
//
//  Created by Maurice Breit on 13.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import NibDesignable
import SwiftIcons
import MMDrawerController



protocol CoachPlusNavigationBarDelegate {
    func profile(sender:UIBarButtonItem)
    func userSettings(sender: UIBarButtonItem)
}

extension CoachPlusNavigationBarDelegate {
    func profile(sender: UIBarButtonItem) {}
    func userSettings(sender: UIBarButtonItem) {}
}

class CoachPlusNavigationBar: UINavigationBar, NibDesignableProtocol {
    
    enum BarButtonType {
        case none
        case back
        case done
        case cancel
        case teams
        case selectedTeam
        case profile
        case userSettings
    }

    var team:Team?
    
    var teamSelectionV:TeamSelectionView?
    
    var coachPlusNavigationBarDelegate:CoachPlusNavigationBarDelegate?
    
    var leftBarButtonType:BarButtonType = .none
    var rightBarButtonType:BarButtonType = .none
    
    
    
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
            case .userSettings:
                btn = self.createUserSettingsBarButton()
        case .cancel:
                btn = self.createCancelBarButton()
            default:
                break
        }
        return btn
    }
    
    func setRightBarButton(item: UINavigationItem) {
        let btn = self.createBarButton(type: self.rightBarButtonType)
        guard btn != nil else {
            return
        }
        item.setRightBarButton(btn, animated: true)
    }
    
    func setLeftBarButton(item: UINavigationItem) {
        let btn = self.createBarButton(type: self.leftBarButtonType)
        guard btn != nil else {
            return
        }
        item.setLeftBarButton(btn, animated: true)
    }
    
    func createDoneBarButton() -> UIBarButtonItem {
        return UIBarButtonItem(title: L10n.done, style: .plain, target: self, action: #selector(done(sender:)))
    }
    
    func createCancelBarButton() -> UIBarButtonItem {
        return UIBarButtonItem(title: L10n.cancel, style: .plain, target: self, action: #selector(cancel(sender:)))
    }
    
    func createProfileBarButton() -> UIBarButtonItem {
        let btn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(profile(sender:)))
        btn.setCoachPlusIcon(fontType: .fontAwesomeSolid(.user), color: .white)
        return btn
    }
    
    func createUserSettingsBarButton() -> UIBarButtonItem {
        let btn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(userSettings(sender:)))
        btn.setCoachPlusIcon(fontType: .fontAwesomeSolid(.cogs), color: .white)
        return btn
    }
    
    func createBackBarButton() -> UIBarButtonItem {
        return UIBarButtonItem(title: L10n.back, style: .plain, target: self, action: #selector(back(sender:)))
    }
    
    func createTeamSelectionBarButton() -> UIBarButtonItem {
        self.teamSelectionV = TeamSelectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 25))
        self.teamSelectionV?.setup(team: team)
        let bbi = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        bbi.customView = self.teamSelectionV
        return bbi
    }
    
    func createTeamsBarButton() -> UIBarButtonItem {
        let btn = UIBarButtonItem(title: L10n.teams, style: .plain, target: self, action: #selector(openSlider(sender:)))
        btn.setCoachPlusIcon(fontType: .fontAwesomeSolid(.tshirt), color: .white)
        return btn
    }
    
    func setStyling() {
        self.barTintColor = .coachPlusBlue
        self.tintColor = UIColor.white
        self.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font : UIFont(name: "Roboto-BoldItalic", size: 14)
        ]
    }
    
    @objc func openSlider(sender:UIBarButtonItem) {
        FlowManager.openDrawer()
    }
    
    @objc func done(sender:UIBarButtonItem) {
        let controller = UIApplication.shared.keyWindow?.rootViewController
        controller?.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancel(sender:UIBarButtonItem) {
        let controller = UIApplication.shared.keyWindow?.rootViewController
        controller?.dismiss(animated: true, completion: nil)
    }
    
    @objc func back(sender:UIBarButtonItem) {
        let controller = UIApplication.shared.keyWindow?.rootViewController
        controller?.navigationController?.popViewController(animated: true)
    }
    
    @objc func profile(sender:UIBarButtonItem) {
        self.coachPlusNavigationBarDelegate?.profile(sender: sender)
    }
    
    @objc func userSettings(sender: UIBarButtonItem) {
        self.coachPlusNavigationBarDelegate?.userSettings(sender: sender)
    }
    
    
}
