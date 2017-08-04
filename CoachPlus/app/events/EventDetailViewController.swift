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
    
    var participationItems = [ParticipationItem]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    
    override func viewDidLoad() {
        self.tableView.register(nib: "ParticipationTableViewCell", reuseIdentifier: "ParticipationTableViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
        super.viewDidLoad()
        self.loadParticipations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.nameLbl.text = self.event?.name
        self.dateTimeLbl.text = self.event?.fromToString()
        self.locationLbl.text = "location"
        self.descriptionLbl.text = event?.description
        
        super.viewWillAppear(animated)
        
    }
    
    func loadParticipations() {
        _ = DataHandler.def.getParticipations(event: self.event!, successHandler: { participationItems in
            self.participationItems = participationItems
            self.tableView.reloadData()
        }, failHandler: { err in
            print(err)
        });
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.participationItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ParticipationTableViewCell", for: indexPath) as! ParticipationTableViewCell
        
        let participationItem = self.participationItems[indexPath.row]
        
        cell.configure(participationItem: participationItem, event: self.event!)
        return cell
    }
}
