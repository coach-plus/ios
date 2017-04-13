//
//  TeamViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 31.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    enum Section:Int {
        case events = 0
        case members = 1
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var team:Team?
    
    var members = [Membership]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let membershipCellNib = UINib(nibName: "MembershipTableViewCell", bundle: nil)
        self.tableView.register(membershipCellNib, forCellReuseIdentifier: "MembershipCell")
        let nib = UINib(nibName: "ReusableTableHeader", bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableHeader")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getMembers()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionEnum = Section(rawValue: section)!
        switch sectionEnum {
        case .events:
            return 0
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
        return UITableViewCell(style: .default, reuseIdentifier: "")
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
    
}
