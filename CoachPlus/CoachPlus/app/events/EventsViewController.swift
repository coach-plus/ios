//
//  EventsViewController.swift
//  CoachPlus
//
//  Created by Maurice Breit on 16.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit

class EventsViewController: CoachPlusViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum Selection {
        case upcoming
        case past
    }

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var upcomingBtn: UIButton!
    @IBOutlet weak var pastBtn: UIButton!
    
    var selection:Selection = .upcoming
    
    var filteredEvents = [Event]()
    
    let selectedColor = UIColor(colorLiteralRed: 74/255, green: 144/255, blue: 226/255, alpha: 0.15)
    
    let unselectedColor = UIColor(colorLiteralRed: 74/255, green: 144/255, blue: 226/255, alpha: 0.05)
    
    var events:[Event] = [Event]()
    
    @IBAction func upcomingTap(_ sender: Any) {
        self.setUpcoming()
    }
    
    @IBAction func pastTap(_ sender: Any) {
        self.setPast()
    }
    
    override func viewDidLoad() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 83
        self.tableView.register(nib: "EventTableViewCell", reuseIdentifier: "EventTableViewCell")
        self.updateUI()
        self.filterEvents()
        super.viewDidLoad()
    }    

    func setUpcoming() {
        guard self.selection != .upcoming else {
            return
        }
        self.selection = .upcoming
        self.updateUI()
        self.filterEvents()
    }
    
    func setPast() {
        guard self.selection != .past else {
            return
        }
        self.selection = .past
        self.updateUI()
        self.filterEvents()
    }
    
    func updateUI() {
        if (self.selection == .upcoming) {
            self.upcomingBtn.backgroundColor = self.selectedColor
            self.pastBtn.backgroundColor = self.unselectedColor
        } else {
            self.upcomingBtn.backgroundColor = self.unselectedColor
            self.pastBtn.backgroundColor = self.selectedColor
        }
    }
    
    func filterEvents() {
        let filterPast = self.selection == .past
        let events = self.events.filter({event in
            return filterPast == event.isInPast()
        })
        self.filteredEvents = events
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
        cell.setup(event: self.filteredEvents[indexPath.row])
        return cell
    }
    
    
}
