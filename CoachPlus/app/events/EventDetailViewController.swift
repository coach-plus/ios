//
//  EventDetailViewController.swift
//  CoachPlus
//
//  Created by Maurice Breit on 17.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit

class EventDetailViewController: CoachPlusViewController, UITableViewDelegate, UITableViewDataSource {
    
    var event:Event?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    
    override func viewDidLoad() {
        self.tableView.register(nib: "ParticipationTableViewCell", reuseIdentifier: "ParticipationTableViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.nameLbl.text = self.event?.name
        self.dateTimeLbl.text = self.event?.fromToString()
        self.locationLbl.text = "location"
        self.descriptionLbl.text = event?.description
        
        super.viewWillAppear(animated)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.event?.participations != nil else {
            return 0
        }
        return (self.event?.participations?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ParticipationTableViewCell", for: indexPath) as! ParticipationTableViewCell
        cell.configure(mode: .didAttend, participation: (self.event?.participations?[indexPath.row])!)
        return cell
    }
}