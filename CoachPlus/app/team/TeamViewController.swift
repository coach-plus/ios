//
//  TeamViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 31.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Hero
import MBProgressHUD
import RxSwift

class TeamViewController: CoachPlusViewController, UITableViewDelegate, UITableViewDataSource, TableHeaderViewButtonDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, CoachPlusNavigationBarDelegate, ImageHelperDelegate, MemberTableViewCellDelegate, CreateEventViewControllerDelegate {
    
    func eventCreated() {
        self.getEvents(showData: true)
    }
    
    func eventChanged(newEvent: Event) {
        self.getEvents(showData: true)
    }
    
    func eventDeleted() {
        self.getEvents(showData: true)
    }
    

    enum Section:Int {
        case events = 0
        case members = 1
    }
    
    enum EventRowType {
        case empty
        case event
        case seeAll
    }
    
    enum Mode {
        case noTeams
        case notAvailable
        case team
        case error
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var members = [Membership]()
    var events = [Event]()
    var allEvents = [Event]()
    
    var notificationManager: NotificationManager?

    let dispatchGroup = DispatchGroup()
    
    var membershipsController:MembershipsController?
    
    var context = CIContext(options: nil)
    
    var imageHelper:ImageHelper?
    
    var headerView: HeaderView?
    
    var mode: Mode = .team
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationManager.shared.setTeamVc(teamVc: self)
        
        let nib = UINib(nibName: "ReusableTableHeader", bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableHeader")
        
        self.tableView.register(nib: "EventTableViewCell", reuseIdentifier: "EventTableViewCell")
        self.tableView.register(nib: "MemberTableViewCell", reuseIdentifier: "MemberTableViewCell")
        self.tableView.register(nib: "SeeAllTableViewCell", reuseIdentifier: "SeeAllTableViewCell")
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 83
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()
        self.isHeroEnabled = true
        self.tableView.isHeroEnabled = true
        self.tableView.heroModifiers = [.cascade]
        
        self.setupRefreshControl()
        
        self.setLeftBarButton(type: .teams)
        self.setRightBarButton(type: .profile)
        
        self.setupNavbar()
        self.setupParallax()
        
        MembershipManager.shared.selectedMembershipSubject.subscribe({event in
            if let membership = event.element {
                self.selectedMembership(membership: membership)
            }
        }).disposed(by: self.disposeBag)
        
        UserManager.shared.userWasEdited.subscribe({event in
            if let user = event.element {
                self.loadData(forceLoadingIndicator: false)
            }
        }).disposed(by: self.disposeBag)
        
        EventManager.shared.eventsChanged.subscribe({ event in
            self.loadData(forceLoadingIndicator: false)
        }).disposed(by: self.disposeBag)
    }
    
    func selectedMembership(membership: Membership?) {
        if (membership == nil) {
            self.mode = .noTeams
            self.tableView.setContentOffset(.zero, animated: true)
            self.members = []
            self.events = []
            self.allEvents = []
        } else {
            self.mode = .team
            if (membership?.id != self.membership?.id) {
                self.tableView.setContentOffset(.zero, animated: true)
                self.members = []
                self.events = []
                self.allEvents = []
            }
        }
        
        self.membership = membership
        self.loadData(forceLoadingIndicator: true)
    }
    
    func setupRefreshControl() {
        
        if (self.headerView != nil) {
            self.headerView!.addSubview(refreshControl)
        } else {
            if #available(iOS 10.0, *) {
                tableView.refreshControl = refreshControl
            } else {
                tableView.addSubview(refreshControl)
            }
        }
        
        
        self.refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    @objc func refresh(_ sender: Any) {
        
        MembershipManager.shared.loadMemberships().done({memberships in
            if let ms = memberships.first(where: { $0.id == self.membership?.id }) {
                self.selectedMembership(membership: ms)
            } else {
                self.selectedMembership(membership: nil)
            }
        })
        
        
    }
    
    func setupParallax() {

        if (self.shouldTableBeEmpty()) {
            
            if (self.headerView != nil) {
                self.headerView?.removeFromSuperview()
                self.headerView = nil
            }
            return
        }
        
        let width = self.view.bounds.width
        let height:CGFloat = width
        
        /*
        let placeholder = UIImage.init(icon: .ionicons(.tshirtOutline), size: CGSize(width: width, height: height), textColor: .coachPlusBlue, backgroundColor: .white)
        */
        
        self.headerView = HeaderView.init(frame: CGRect(x: 0, y: 0, width: width, height: height), team: (self.membership?.team ?? nil) ?? nil)
        self.tableView.tableHeaderView  = headerView
        
//        headerView.setup(team: (self.membership?.team ?? nil) ?? nil)
        self.addSettingsButtonToHeaderView()
        
        
        
        /*
        if !(self.membership?.team?.image == nil || self.membership?.team?.image == "") {
            let urlRequest = URLRequest(url: URL(string: (self.membership?.team?.getTeamImageUrl())!)!)
            downloader.download(urlRequest) { response in
                if let image = response.result.value {
                    self.tableView.tableHeaderView  = HeaderView.init(frame: CGRect(x: 0, y: 0, width: width, height: height), image: image)
                    self.addSettingsButtonToHeaderView()
                }
            }
        }*/
        
        
        
    }
    
    func addSettingsButtonToHeaderView() {
        
        if (!(self.membership?.isCoach())!) {
            return
        }
        
        if let headerView = self.tableView.tableHeaderView as? HeaderView {
            let container = headerView.containerView
            
            let view = UIView()
            view.backgroundColor = .coachPlusBlue
            view.layer.cornerRadius = 5;
            view.layer.masksToBounds = true;
            view.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(view)
            view.trailingAnchor.constraint(equalTo: container.layoutMarginsGuide.trailingAnchor, constant: -10).isActive = true
            view.bottomAnchor.constraint(equalTo: container.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
            view.widthAnchor.constraint(equalToConstant: 30).isActive = true
            view.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            let btn = UIButton()
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.setIcon(icon: .googleMaterialDesign(.modeEdit), iconSize: 20, color: .white, backgroundColor: .clear, forState: .normal)
            btn.addTarget(self, action: #selector(TeamViewController.editTapped(sender:)) , for: .touchUpInside)
            view.addSubview(btn)
            
            btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
            btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
            btn.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            btn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        }
    }
    
    @objc func editTapped(sender: UIButton) {
        
        let editTeamNavVc: CoachPlusNavigationViewController = FlowManager.createEditTeamVc()
        let editTeamVc = editTeamNavVc.children[0] as! CreateTeamViewController
        editTeamVc.mode = .Edit
        editTeamVc.team = self.membership?.team
        self.present(editTeamNavVc, animated: true, completion: nil)
        
        /*
        self.imageHelper = ImageHelper(vc: self)
        self.imageHelper?.showImagePicker()
        */
    }
    
    func imageSelectedAndCropped(image: UIImage) {
        DataHandler.def.updateTeamImage(teamId: (self.membership?.team?.id)!, image: image.toTeamImage().toBase64()).done({ team in
            self.membership?.team = team
            self.setupParallax()
            if (self.membershipsController != nil) {
                self.membershipsController?.loadTeams()
            }
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let headerView = self.tableView.tableHeaderView as? HeaderView {
            headerView.scrollViewDidScroll(scrollView: scrollView)
        }
        
        
    }
    
    func setupNavbar() {
        self.setNavbarTitle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.clearSelection()
        self.enableDrawer()
    }
    
    func loadData(forceLoadingIndicator: Bool) {
        if (self.membership?.team != nil) {
            if ((self.members.count == 0 && self.events.count == 0) || forceLoadingIndicator) {
                MBProgressHUD.createHUD(view: self.view, msg: L10n.loading)
            }
            
            self.getMembers()
            self.getEvents()
            self.dispatchGroup.notify(queue: .main) {
                self.showData()
                self.refreshControl.endRefreshing()
            }
        } else {
            self.showData()
        }
        
    }
    
    func showData() {
        self.setupNavbar()
        self.setupParallax()
        self.tableView.reloadData()
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getMembers(showData: Bool = false) {
        self.dispatchGroup.enter()
        DataHandler.def.getMembers(teamId: (self.membership?.team?.id)!).done({ memberships in
            self.members = memberships
            self.dispatchGroup.leave()
        }).catch({error in
            if let apiError = error as? ApiError, apiError != nil, apiError.statusCode == 500 {
                self.mode = .notAvailable
            }
            print(error)
            self.dispatchGroup.leave()
        }).finally {
            if (showData == true) {
                self.showData()
            }
        }
    }
    
    func getEvents(showData: Bool = false) {
        self.dispatchGroup.enter()
        DataHandler.def.getEventsOfTeam(team: (self.membership?.team!)!).done({ events in
            self.allEvents = events.sorted(by: {(eventA, eventB) in
                return eventA.start < eventB.start
            })
            self.events = self.getNextEvents()
            self.dispatchGroup.leave()
        }).catch({error in
            if let apiError = error as? ApiError, apiError != nil, apiError.statusCode == 401 {
                self.mode = .notAvailable
            }
            print(error)
            self.dispatchGroup.leave()
        }).finally {
            if (showData == true) {
                self.showData()
            }
        }
    }
    
    func getNextEvents() -> [Event]{
        return self.allEvents.filter({ event in
            return event.isInPast() == false
        })
    }
    
    func shouldTableBeEmpty() -> Bool {
        return (self.mode == .notAvailable || self.mode == .noTeams || self.mode == .error || self.membership?.team == nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if (self.shouldTableBeEmpty()) {
            return 0
        }
        
        return 2
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.shouldTableBeEmpty()) {
            return 0
        }
        
        let sectionEnum = Section(rawValue: section)!
        switch sectionEnum {
        case .events:
            return self.numberOfEventRows()
        case .members:
            return self.members.count
        }
    }
    
    func hasEvents() -> Bool {
        return self.events.count > 0
    }
    
    
    func numberOfEventRows() -> Int {
        
        let count = self.events.count
        
        if (self.hasEvents()) {
            if (count >= 3) {
                return 4
            }
            return count + 1
        }
        
        return 2
    }
    
    func eventRowType(_ indexPath:IndexPath) -> EventRowType {
        guard self.hasEvents() else {
            if (indexPath.row == 0) {
                return .empty
            } else {
                return .seeAll
            }
            
        }
        guard indexPath.row < self.numberOfEventRows()-1 else {
            return .seeAll
        }
        return .event
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (self.membership?.team == nil) {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "abc")
            cell.textLabel?.text = "Nothing"
            return cell
        }
        
        let sectionEnum = Section(rawValue: indexPath.section)!
        
        if (sectionEnum == .events) {
            return eventTableCell(indexPath: indexPath)
        }
        if (sectionEnum == .members) {
            return memberTableCell(indexPath: indexPath)
        }
        return UITableViewCell()
    }
    
    func eventTableCell(indexPath:IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell
        
        switch self.eventRowType(indexPath) {
        case .empty:
            cell = UITableViewCell(style: .default, reuseIdentifier: "NoEventsCell")
            cell.textLabel?.text = L10n.thereAreNoPlannedEvents
        case .seeAll:
            let cell1 = self.tableView.dequeueReusableCell(withIdentifier: "SeeAllTableViewCell", for: indexPath) as! SeeAllTableViewCell
            cell1.textLbl.text = L10n.showAllEvents
            cell = cell1
        case .event:
            let cell1 = self.tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
            let event = self.events[indexPath.row]
            cell1.setup(event: event)
            cell = cell1
        }
        
        return cell
        
    }
    
    func memberTableCell(indexPath:IndexPath) -> UITableViewCell {
        
        let cell1 = self.tableView.dequeueReusableCell(withIdentifier: "MemberTableViewCell", for: indexPath)
        let cell = cell1 as! MemberTableViewCell
        
        let membership = self.members[indexPath.row]
        
        cell.setup(membership: membership, ownMembership: self.membership!, vc: self)
        
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (self.shouldTableBeEmpty()) {
            return nil
        }
        
        let sectionType = Section(rawValue: section)!
        
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableHeader")
        let view = cell as! ReusableTableHeader
        
        if (self.membership!.isCoach() || (sectionType == Section.members && (self.membership?.team?.isPublic)!)) {
            view.tableHeader.btn.tag = section
            view.tableHeader.delegate = self
            view.tableHeader.showBtn = true
        } else {
            view.tableHeader.showBtn = false
        }
        
        
        switch sectionType {
        case .events:
            view.tableHeader.title = L10n.events
        default:
            view.tableHeader.title = L10n.members
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (self.shouldTableBeEmpty()) {
            return 0
        }
        return 45
    }
    
    func newEvent() {
        let vc = FlowManager.createEditEventVc(mode: .Create, membership: self.membership, event: nil, delegate: self)
        self.present(vc, animated: true, completion: nil)
    }
    
    func newMember() {
        DataHandler.def.createInviteLink(team: (self.membership?.team!)!, validDays: nil).done({ link in
            
            let url = URL(string: link)!
            
            let vc = UIActivityViewController(activityItems: [L10n.joinThisPrivateTeam, url], applicationActivities: nil)
            vc.excludedActivityTypes =
                [UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.postToFlickr,
                 UIActivity.ActivityType.postToVimeo, UIActivity.ActivityType.openInIBooks]
            self.present(vc, animated: true, completion: nil)
            
        }).catch({ err in
            print(err)
        })
    }
    
    func tableViewHeaderBtnTap(_ sender: Any) {
        
        let section = Section(rawValue: (sender as AnyObject).tag)
        
        guard (section != nil) else {
            return
        }
        
        switch section! {
        case .events:
            self.newEvent()
        case .members:
            self.newMember()
        default:
            return;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.mode == .team) {
            if (indexPath.section == Section.events.rawValue) {
                switch self.eventRowType(indexPath) {
                case .seeAll:
                    let vc = UIStoryboard(name: "Events", bundle: nil).instantiateInitialViewController() as! EventsViewController
                    vc.events = self.allEvents
                    vc.membership = self.membership
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                case .empty:
                    return
                case .event:
                    let event = self.events[indexPath.row]
                    
                    let cell = self.tableView.cellForRow(at: indexPath)
                    
                    self.pushToEventDetail(currentVC: self, event: event)
                    return
                default:
                    return
                }
            }
            if (indexPath.section == Section.members.rawValue) {
                let vc = FlowManager.profileVc()
                let user = self.members[indexPath.row].user
                vc.isHeroEnabled = true
                vc.heroId = "\(user!.id)"
                vc.user = user
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage? {
        
        switch self.mode {
        case .notAvailable:
            return UIImage(icon: .fontAwesomeSolid(.lock), size: CGSize.init(width: 50, height: 50), textColor: .coachPlusBlue, backgroundColor: .clear)
        case .error:
            return nil
        case .noTeams:
            return UIImage(icon: .fontAwesomeSolid(.lifeRing), size: CGSize.init(width: 50, height: 50), textColor: .coachPlusBlue, backgroundColor: .clear)
        default:
            return nil
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString? {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28)] as Dictionary!
        var string = ""
        
        switch self.mode {
            case .notAvailable:
                string = L10n.thisTeamIsNotAvailable
                break
            case .noTeams:
                return nil
            case .error:
                string = L10n.thereWasAnErrorLoadingThisTeam
                break
            default:
                return nil
            }
        
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        return attributedString
    }
    
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)] as Dictionary!
        var string = ""
        
        switch self.mode {
        case .notAvailable:
            string = ""
            break
            
        case .noTeams:
            string = L10n.youDoNotHaveATeamYet
            break
            
        default:
            return nil
        }
        
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        return attributedString
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0), NSAttributedString.Key.foregroundColor: UIColor.coachPlusBlue] as Dictionary!
        var string = ""
        
        switch self.mode {
            
        case .noTeams:
            string = L10n.createTeam
            break
            
        default:
            return nil
        }
        
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        return attributedString
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        let vc = FlowManager.createEditTeamVc()
        self.present(vc, animated: true, completion: nil)
    }
    
    func profile(sender:UIBarButtonItem) {
        
        let vc = FlowManager.profileVc()
        
        let user = UserManager.getUser()
        vc.user = user
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func dataChanged() {
        self.loadData(forceLoadingIndicator: false)
    }
    
    
}
