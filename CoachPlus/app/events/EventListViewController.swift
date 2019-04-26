//
//  EventsViewController.swift
//  CoachPlus
//
//  Created by Maurice Breit on 16.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import DZNEmptyDataSet
import SwiftIcons

class EventListViewController: CoachPlusViewController, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, EventDetailCellDeleteDelegate {
    
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
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 83
        self.tableView.register(nib: "EventTableViewCell", reuseIdentifier: "EventTableViewCell")
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        EventManager.shared.eventsChanged.subscribe({ event in
            self.loadEvents()
        }).disposed(by: self.disposeBag)
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
        self.pushToEventDetail(currentVC: self, event: event)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        switch self.selection {
        case .past:
            return IndicatorInfo(title: "PAST_EVENTS".localize())
        case .upcoming:
            return IndicatorInfo(title: "UPCOMING_EVENTS".localize())
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadEvents()
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        let size = CGSize(width: 100.0, height: 100.0)
        return UIImage.init(icon: .googleMaterialDesign(.sentimentDissatisfied), size: size, textColor: .coachPlusBlue, backgroundColor: .clear)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)] as Dictionary!
        
        let string = "NO_EVENTS".localize()
        
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        
        return attributedString
    }
    
    func delete(event: Event) {
        self.events = self.events.filter({ e in
            return e.id != event.id
        })
        self.tableView.reloadData()
    }
    
    func loadEvents() {
        DataHandler.def.getEventsOfTeam(team: (MembershipManager.shared.selectedMembership!.team!)).done({ events in
            if (self.selection == .upcoming) {
                self.events = events.upcoming()
            } else if (self.selection == .past) {
                self.events = events.past()
            }
            self.tableView.reloadData()
        })
    }
}
