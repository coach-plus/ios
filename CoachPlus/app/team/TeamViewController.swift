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
import AlamofireImage

class TeamViewController: CoachPlusViewController, UITableViewDelegate, UITableViewDataSource, TableHeaderViewButtonDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, CoachPlusNavigationBarDelegate, ImageHelperDelegate {

    enum Section:Int {
        case events = 0
        case members = 1
    }
    
    enum EventRowType {
        case empty
        case event
        case seeAll
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var members = [Membership]()
    var events = [Event]()
    var allEvents = [Event]()
    
    var membershipsController:MembershipsController?
    
    let downloader = ImageDownloader()
    
    var context = CIContext(options: nil)
    
    var imageHelper:ImageHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ReusableTableHeader", bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableHeader")
        
        self.tableView.register(nib: "EventTableViewCell", reuseIdentifier: "EventTableViewCell")
        self.tableView.register(nib: "MemberTableViewCell", reuseIdentifier: "MemberTableViewCell")
        self.tableView.register(nib: "SeeAllTableViewCell", reuseIdentifier: "SeeAllTableViewCell")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 83
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()
        
        if (self.membership != nil) {
            MembershipManager.shared.selectMembership(membership: self.membership!)
        }
        
        self.setupNavbar()
        
        self.setupParallax()
        
        super.viewDidLoad()
    }
    
    func setupParallax() {

        if (self.membership == nil) {
            return
        }
        
        let width = self.view.bounds.width
        let height:CGFloat = 200.0
        
        let placeholder = UIImage.init(icon: .ionicons(.tshirtOutline), size: CGSize(width: width, height: height), textColor: .coachPlusBlue, backgroundColor: .white)
        
        self.tableView.tableHeaderView  = HeaderView.init(frame: CGRect(x: 0, y: 0, width: width, height: height), image: placeholder)
        self.addSettingsButtonToHeaderView()
        
        if !(self.membership?.team?.image == nil || self.membership?.team?.image == "") {
            let urlRequest = URLRequest(url: URL(string: (self.membership?.team?.getTeamImageUrl())!)!)
            downloader.download(urlRequest) { response in
                if let image = response.result.value {
                    self.tableView.tableHeaderView  = HeaderView.init(frame: CGRect(x: 0, y: 0, width: width, height: height), image: image)
                    self.addSettingsButtonToHeaderView()
                }
            }
        }
        
        
        
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
    
    func editTapped(sender: UIButton) {
        self.imageHelper = ImageHelper(vc: self)
        self.imageHelper?.showImagePicker()
    }
    
    func imageSelectedAndCropped(image: UIImage) {
        _ = DataHandler.def.updateTeamImage(teamId: (self.membership?.team?.id)!, image: image.toTeamImage().toBase64(), successHandler: { team in
            self.membership?.team = team
            self.setupParallax()
            if (self.membershipsController != nil) {
                self.membershipsController?.loadTeams()
            }
        }, failHandler: { err in })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let headerView = self.tableView.tableHeaderView as? HeaderView {
            headerView.scrollViewDidScroll(scrollView: scrollView)
        }
        
    }
    
    func setupNavbar() {
        let navbar = self.navigationController?.navigationBar as! CoachPlusNavigationBar
        
        navbar.setLeftBarButtonType(type: .teams)
        
        /*
        if (self.membership != nil && self.membership?.team != nil) {
            navbar.setTeamSelection(team: self.membership?.team!)
        } else {
            navbar.setLeftBarButtonType(type: .teams)
        }*/
        
        navbar.setRightBarButtonType(type: .profile)
        
        self.setupNavBarDelegate()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (self.membership?.team != nil) {
            self.getMembers()
            self.getEvents()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getMembers() {
        _ = DataHandler.def.getMembers(teamId: (self.membership?.team?.id)!, successHandler: { memberships in
            self.members = memberships
            self.tableView.reloadData()
        }, failHandler: { err in
            print(err)
        })
    }
    
    func getEvents() {
        _ = DataHandler.def.getEventsOfTeam(team: (self.membership?.team!)!, successHandler: { events in
            self.allEvents = events.sorted(by: {(eventA, eventB) in
                return eventA.start < eventB.start
            })
            self.events = self.getNextEvents()
            self.tableView.reloadData()
        }, failHandler: { err in
            print(err)
        })
    }
    
    func getNextEvents() -> [Event]{
        return self.allEvents.filter({ event in
            return event.isInPast() == false
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if (self.membership?.team == nil) {
            return 0
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.membership?.team == nil) {
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
            cell.textLabel?.text = "No Events"
        case .seeAll:
            let cell1 = self.tableView.dequeueReusableCell(withIdentifier: "SeeAllTableViewCell", for: indexPath) as! SeeAllTableViewCell
            cell1.textLbl.text = "See all Events"
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
        
        cell.setup(membership: membership)
        
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (self.membership?.team == nil) {
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
            view.tableHeader.title = "EVENTS"
        default:
            view.tableHeader.title = "MEMBERS"
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (self.membership?.team == nil) {
            return 0
        }
        return 45
    }
    
    func newEvent() {
        print("new Event")
        let vc = UIStoryboard(name: "CreateEvent", bundle: nil).instantiateInitialViewController() as! CreateEventViewController
        vc.membership = self.membership
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func newMember() {
        _ = DataHandler.def.createInviteLink(team: (self.membership?.team!)!, validDays: nil, successHandler: { link in
            
            let url = URL(string: link)!
            
            let vc = UIActivityViewController(activityItems: ["Aloha! Join your awesome team", url], applicationActivities: nil)
            vc.excludedActivityTypes =
                [UIActivityType.assignToContact, UIActivityType.saveToCameraRoll, UIActivityType.postToFlickr,
                 UIActivityType.postToVimeo, UIActivityType.openInIBooks]
            self.present(vc, animated: true, completion: nil)
            
        }, failHandler: { err in
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
        if (indexPath.section == Section.events.rawValue) {
            switch self.eventRowType(indexPath) {
            case .seeAll:
                let vc = UIStoryboard(name: "Events", bundle: nil).instantiateInitialViewController() as! EventsViewController
                vc.events = self.allEvents
                self.navigationController?.pushViewController(vc, animated: true)
                return
            case .empty:
                return
            case .event:
                let event = self.events[indexPath.row]
                
                let cell = self.tableView.cellForRow(at: indexPath)
                
                self.pushToEventDetail(event: event)
                return
            default:
                return
            }
        }
        if (indexPath.section == Section.members.rawValue) {
            let vc = FlowManager.profileVc()
            let user = self.members[indexPath.row].user
            vc.isHeroEnabled = true
            vc.user = user
            vc.heroId = "\(user!.id)"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let attributes = [
            NSFontAttributeName: UIFont.fontAwesome(ofSize: 50),
            NSForegroundColorAttributeName: UIColor.coachPlusBlue] as Dictionary!
        
        
        let attributedString = NSAttributedString(string: String.fontAwesomeIcon(name: .lifeRing), attributes: attributes)
        
        return attributedString
        
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 20)] as Dictionary!
        
        let string = "Why so lonely?\nCreate a team and invite your buddies!"
        
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        
        return attributedString
    }
    
    func profile(sender:UIBarButtonItem) {
        
        let vc = FlowManager.profileVc()
        
        let user = UserManager.getUser()
        vc.user = user
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
