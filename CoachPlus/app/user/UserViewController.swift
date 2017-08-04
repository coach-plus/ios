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
import ImagePicker

class UserViewController: CoachPlusViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, ImageHelperDelegate {

    var user:User?
    var memberships = [Membership]()
    var loaded = false
    var imageHelper: ImageHelper?
    
    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var emailL: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editImageBtn: UIButton!
    
    @IBAction func editImageBtnTapped(_ sender: Any) {
        self.showImagePicker()
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        if (self.heroId != "") {
            self.isHeroEnabled = true
            self.imageV.heroID = "\(self.heroId)/image"
        }
        
        self.editImageBtn.setIcon(icon: .googleMaterialDesign(.modeEdit), iconSize: 20, color: .coachPlusGrey, backgroundColor: .clear, forState: .normal)
        
        self.editImageBtn.isHidden = !(self.membership?.user?.id == user?.id)
        
        
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
    
    func showImagePicker() {
        self.imageHelper = ImageHelper(vc: self)
        self.imageHelper?.showImagePicker()
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
    
    func imageSelectedAndCropped(image: UIImage) {
        self.updateUserImage(image: image)
    }
    
    func updateUserImage(image:UIImage) {
        let userImage = image.toUserImage().toBase64()
        _ = DataHandler.def.updateUserImage(image: userImage, successHandler: { user in
            UserManager.storeUser(user: user)
            self.user = user
            self.displayUser()
        }, failHandler: {err in })
    }

}
