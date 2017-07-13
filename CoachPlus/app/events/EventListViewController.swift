//
//  EventsViewController.swift
//  CoachPlus
//
//  Created by Maurice Breit on 16.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class EventListViewController: CoachPlusViewController, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider {
    
    
    enum Selection {
        case upcoming
        case past
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var selection:Selection = .upcoming
    
    //let selectedColor = UIColor(colorLiteralRed: 74/255, green: 144/255, blue: 226/255, alpha: 0.15)
    //let unselectedColor = UIColor(colorLiteralRed: 74/255, green: 144/255, blue: 226/255, alpha: 0.05)
    
    var events:[Event] = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 83
        self.tableView.register(nib: "EventTableViewCell", reuseIdentifier: "EventTableViewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
        cell.setup(event: self.events[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = self.events[indexPath.row]
        self.pushToEventDetail(event: event)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        switch self.selection {
        case .past:
            return IndicatorInfo(title: "VERGANGENE EVENTS")
        case .upcoming:
            return IndicatorInfo(title: "ZUKÜNFTIGE EVENTS")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
}