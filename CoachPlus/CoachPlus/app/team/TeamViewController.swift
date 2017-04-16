//
//  TeamViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 31.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit

class TeamViewController: CoachPlusViewController, UITableViewDelegate, UITableViewDataSource, TableHeaderViewButtonDelegate {

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
    
    var team:Team?
    
    var members = [Membership]()
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ReusableTableHeader", bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableHeader")
        
        self.tableView.register(nib: "EventTableViewCell", reuseIdentifier: "EventTableViewCell")
        self.tableView.register(nib: "MemberTableViewCell", reuseIdentifier: "MemberTableViewCell")
        self.tableView.register(nib: "SeeAllTableViewCell", reuseIdentifier: "SeeAllTableViewCell")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 83
        
        super.viewDidLoad()
        //self.setCoachPlusLogo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getMembers()
        self.getEvents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getMembers() {
        _ = DataHandler.def.getMembers(teamId: (self.team?.id)!, successHandler: { memberships in
            self.members = memberships
            self.tableView.reloadData()
        }, failHandler: { err in
            print(err)
        })
    }
    
    func getEvents() {
        _ = DataHandler.def.getEventsOfTeam(team: self.team!, successHandler: { events in
            self.events = events
            self.tableView.reloadData()
        }, failHandler: { err in
            print(err)
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        return 1
    }
    
    func eventRowType(_ indexPath:IndexPath) -> EventRowType {
        guard self.hasEvents() else {
            return .empty
        }
        guard indexPath.row < self.numberOfEventRows()-1 else {
            return .seeAll
        }
        return .event
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableHeader")
        let view = cell as! ReusableTableHeader
        view.tableHeader.btn.tag = section
        view.tableHeader.delegate = self
        switch Section(rawValue: section)! {
        case .events:
            view.tableHeader.title = "EVENTS"
        default:
            view.tableHeader.title = "MEMBERS"
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func newEvent() {
        print("new Event")
        let vc = UIStoryboard(name: "CreateEvent", bundle: nil).instantiateInitialViewController()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func newMember() {
        print("new member")
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
        
        if self.eventRowType(indexPath) == .seeAll {
            if (indexPath.section == Section.events.rawValue) {
                let vc = UIStoryboard(name: "Events", bundle: nil).instantiateInitialViewController() as! EventsViewController
                vc.events = self.events
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        
    }
}
