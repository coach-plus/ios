//
//  UserViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 10.05.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import ImagePicker

class UserViewController: CoachPlusViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, ImageHelperDelegate, MembershipTableViewCellActionDelegate, CoachPlusNavigationBarDelegate {

    var user:User?
    var memberships = [Membership]()
    var imageHelper: ImageHelper?
    
    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var emailL: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editImageBtn: UIButton!
    
    @IBAction func editImageBtnTapped(_ sender: Any) {
        self.showImagePicker()
    }
    
    @IBOutlet weak var titleView: TitleView!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.defaultBackground
        
        if (self.heroId != "") {
            self.isHeroEnabled = true
            self.imageV.heroID = "\(self.heroId)/image"
            self.nameL.heroID = "\(self.heroId)/text"
            self.navigationItem.titleView?.heroID = "\(self.heroId)/text"
        }
        
        self.editImageBtn.setCoachPlusIcon(fontType: .googleMaterialDesign(.modeEdit), color: UIColor.coachPlusBlue)
        
        
        guard self.user != nil else {
            if (self.isBeingPresented) {
                self.dismiss(animated: false, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: false)
            }
            return
        }
        
        self.editImageBtn.isHidden = !UserManager.isSelf(userId: self.user!.id)
        
        self.displayUser()
        self.setupTableView()
        self.setupNavbar()
        
        self.getMemberships()
        
        UserManager.shared.userWasEdited.subscribe({ event in
            if let user = event.element, user != nil {
                self.user = user
                self.displayUser()
            }
        }).disposed(by: self.disposeBag)
        
    }

    func setupNavbar() {
        if (UserManager.isSelf(userId: self.user!.id)) {
            self.setRightBarButton(type: .userSettings)
        }
        self.setupNavBarDelegate()
    }

    func userSettings(sender: UIBarButtonItem) {
        if (self.user != nil && UserManager.isSelf(userId: self.user!.id)) {
            let navVc = FlowManager.userSettingsVc()
            let settingsVc = navVc.children[0] as! UserSettingsViewController
            self.presentModally(navVc, animated: true, completion: nil)
        }
    }
    
    
    func getMemberships() {
        self.loaded = false
        DataHandler.def.getMembershipsOfUser(userId: self.user!.id).done({ memberships in
            
            self.memberships = memberships
            self.loaded = true
            self.tableView.reloadData()
            
        })
    }
    
    func showImagePicker() {
        self.imageHelper = ImageHelper(vc: self)
        self.imageHelper?.showImagePicker(vc: self)
    }
    
    func displayUser() {
        self.nameL.text = self.user!.fullname
        self.navigationItem.title = self.user!.firstname
        
        var text = "";
        
        if (self.user?.id == Authentication.getUser().id) {
            self.emailL.text = Authentication.getUser().email
            text = L10n.youAreInTheFollowingTeams
        } else {
            self.emailL.isHidden = true
            text = L10n.playerIsInTheFollowingTeams(self.user!.firstname)
        }
        
        self.titleView.title = text.localize()
        
        self.imageV.setUserImage(user: self.user!, showPlaceholder: true)
    }
    
    func setupTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 83
        self.tableView.register(nib: "MembershipTableViewCell", reuseIdentifier: "MembershipCell")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memberships.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MembershipCell", for: indexPath) as! MembershipTableViewCell
        let membership = self.memberships[indexPath.row]
        if (UserManager.isSelf(userId: self.user!.id)) {
            membership.user = self.user!
        }
        cell.actionDelegate = self
        cell.inMembershipList = false
        cell.setup(membership: membership)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let membership = self.memberships[indexPath.row]
        
        if (membership.team!.id == MembershipManager.shared.selectedMembership?.team!.id) {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        if (UserManager.isSelf(userId: user?.id)) {
            FlowManager.selectAndOpenTeam(vc: self, teamId: membership.team!.id)
            self.navigationController?.popViewController(animated: true)
            return
        } else {
            if (membership.joined == true) {
                FlowManager.selectAndOpenTeam(vc: self, teamId: membership.team!.id)
                self.navigationController?.popViewController(animated: true)
                return
            } else if (membership.team!.isPublic) {
                self.showJoinTeamActionSheet(team: membership.team!)
            }
        }
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage? {
        if (self.loaded == false) {
            return nil
        }
        return UIImage(icon: .fontAwesomeSolid(.lifeRing), size: CGSize.init(width: 50, height: 50), textColor: .coachPlusBlue, backgroundColor: .clear)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        if (self.loaded) {
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)] as Dictionary<NSAttributedString.Key, Any>!
            
            var string = L10n.youDoNotHaveATeamYet
            
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            return attributedString
        } else {
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)] as Dictionary<NSAttributedString.Key, Any>!
            
            var string = L10n.loading
            
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            return attributedString
        }
        
    }
    
    func imageSelectedAndCropped(image: UIImage) {
        self.updateUserImage(image: image)
    }
    
    func updateUserImage(image:UIImage) {
        let userImage = image.toUserImage().toBase64()
        DataHandler.def.updateUserImage(image: userImage).done({ user in
            UserManager.storeUser(user: user)
            self.user = user
            self.displayUser()
        })
    }
    
    func showJoinTeamActionSheet(team: Team) {
        let alertController = UIAlertController(title: L10n.joinTeam, message: L10n.areYouSureThatYouWantToLeaveTeamName(team.name), preferredStyle: .actionSheet)
        
        let yesButton = UIAlertAction(title: L10n.joinTeam.localize(), style: .default, handler: { (action) -> Void in
            
            self.loadData(text: L10n.loading, promise: DataHandler.def.joinTeam(inviteId: team.id, teamType: JoinTeamViewController.TeamType.publicTeam)).done({ apiResponse in
                DropdownAlert.success(message: L10n.successfullyJoinedX(team.name))
                FlowManager.selectAndOpenTeam(vc: self, teamId: team.id)
                self.navigationController?.popViewController(animated: true)
            })
        })
        
        let noButton = UIAlertAction(title: L10n.cancel, style: .cancel, handler: { (action) -> Void in })
        
        alertController.addAction(yesButton)
        alertController.addAction(noButton)
        
        self.presentModally(alertController, animated: true, completion: nil)
    }
    
    func showLeaveTeamActionSheet(membership: Membership) {
        let alertController = UIAlertController(title: L10n.leaveTeam, message: L10n.areYouSureThatYouWantToLeaveTeamName(membership.team!.name), preferredStyle: .actionSheet)
        
        let yesButton = UIAlertAction(title: L10n.leaveTeam, style: .default, handler: { (action) -> Void in
            
            self.loadData(text: L10n.loading, promise: DataHandler.def.leaveTeam(teamId: membership.team!.id)).done({ apiResponse in
            
                let selectedMembership = MembershipManager.shared.selectedMembership
                if (selectedMembership != nil) {
                    if (membership.team!.id == selectedMembership!.team!.id) {
                        DropdownAlert.success(message: L10n.successfullyLeftTeamX(membership.team!.name))
                        FlowManager.selectAndOpenTeam(vc: self, teamId: nil)
                        self.navigationController?.popViewController(animated: true)
                        return
                    }
                }
                self.getMemberships()
            })
        })
        
        let noButton = UIAlertAction(title: L10n.cancel, style: .cancel, handler: { (action) -> Void in })
        
        alertController.addAction(yesButton)
        alertController.addAction(noButton)
        
        self.presentModally(alertController, animated: true, completion: nil)
    }
    
    func showActions(membership: Membership, mode: MembershipTableViewCell.Mode) {
        switch mode {
        case .Join:
            self.showJoinTeamActionSheet(team: membership.team!)
            break
        case .Leave:
            self.showLeaveTeamActionSheet(membership: membership)
            break
        default: break
            // do nothing
        }
    }
}
