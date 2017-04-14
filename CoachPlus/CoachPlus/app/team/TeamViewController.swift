//
//  TeamViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 31.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TableHeaderViewButtonDelegate {

    enum Section:Int {
        case events = 0
        case members = 1
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var team:Team?
    
    var members = [Membership]()
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let membershipCellNib = UINib(nibName: "MembershipTableViewCell", bundle: nil)
        self.tableView.register(membershipCellNib, forCellReuseIdentifier: "MembershipCell")
        
        let nib = UINib(nibName: "ReusableTableHeader", bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableHeader")
        
        self.tableView.register(nib: "EventTableViewCell", reuseIdentifier: "EventTableViewCell")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 83
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
            return self.events.count
        case .members:
            return self.members.count
        }
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
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
        
        let event = self.events[indexPath.row]
        
        cell.setup(event: event)
        
        return cell
    }
    
    func memberTableCell(indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MembershipCell") as! MembershipTableViewCell
        
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
}
