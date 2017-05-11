//
//  UserViewController.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 10.05.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import AlamofireImage
import DZNEmptyDataSet

class UserViewController: CoachPlusViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    var user:User?
    var memberships = [Membership]()
    var loaded = false
    
    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var emailL: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard self.user != nil else {
            if (self.isBeingPresented) {
                self.dismiss(animated: false, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: false)
            }
            return
        }
        self.displayUser()
        self.setupTableView()
        
        self.memberships = MembershipManager.shared.getMemberships()
    }
    
    func displayUser() {
        self.nameL.text = self.user!.fullname
        self.emailL.text = self.user!.email
        self.imageV.setUserImage(user: self.user!)
    }
    
    func setupTableView() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
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
        cell.setup(membership: membership)
        return cell
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        if (self.loaded == true) {
            let attributes = [
                NSFontAttributeName: UIFont.fontAwesome(ofSize: 50),
                NSForegroundColorAttributeName: UIColor.coachPlusBlue] as Dictionary!
            
            
            let attributedString = NSAttributedString(string: String.fontAwesomeIcon(name: .lifeRing), attributes: attributes)
            
            return attributedString
        }
        
        return NSAttributedString(string: "")
        
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 20)] as Dictionary!
        
        var string = ""
        
        if (self.loaded) {
            string = "Why so lonely?\nCreate a team and invite your buddies!"
        } else {
            string = "Loading.."
        }
        
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        return attributedString
        
    }
    

}
