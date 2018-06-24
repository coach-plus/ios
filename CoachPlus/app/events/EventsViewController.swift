//
//  EventsViewController.swift
//  CoachPlus
//
//  Created by Maurice Breit on 07.07.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import XLPagerTabStrip

class EventsViewController: ButtonBarPagerTabStripViewController {
    
    var upcomingEventsViewController: EventListViewController?
    var pastEventsViewController: EventListViewController?
    
    var events: [Event] = []
    
    override func viewDidLoad() {
        
        let storyboard = UIStoryboard(name: "Events", bundle: nil)
        
        self.upcomingEventsViewController = storyboard.instantiateViewController(withIdentifier: "EventListViewController") as? EventListViewController
        self.pastEventsViewController = storyboard.instantiateViewController(withIdentifier: "EventListViewController") as? EventListViewController
        
        self.upcomingEventsViewController?.selection = EventListViewController.Selection.upcoming
        self.pastEventsViewController?.selection = EventListViewController.Selection.past
        
        self.upcomingEventsViewController?.events = self.filterEvents(selection: .upcoming)
        self.pastEventsViewController?.events = self.filterEvents(selection: .past)
        
        self.settings.style.buttonBarBackgroundColor = UIColor.white
        self.settings.style.selectedBarBackgroundColor = UIColor.coachPlusBlue
        
        self.settings.style.buttonBarMinimumLineSpacing = 0
        
        self.settings.style.buttonBarBackgroundColor = UIColor.white
        
        self.settings.style.buttonBarItemTitleColor = UIColor.coachPlusGrey
        
        self.settings.style.buttonBarItemBackgroundColor = UIColor.white
        
        self.settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 13)
        self.settings.style.buttonBarHeight = 2.0
        self.settings.style.selectedBarHeight = 2.0
        
        self.changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = UIColor.coachPlusGrey
            newCell?.label.textColor = UIColor.coachPlusBlue
            
            if animated {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                })
            }
            else {
                newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
        
        if let popGest = self.navigationController?.interactivePopGestureRecognizer {
            containerView.panGestureRecognizer.require(toFail: popGest)
        }
        
        super.viewDidLoad()
        
    }
    
    func filterEvents(selection: EventListViewController.Selection) -> [Event] {
        let filterPast = selection == .past
        let events = self.events.filter({event in
            return filterPast == event.isInPast()
        })
        return events
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [self.upcomingEventsViewController!, self.pastEventsViewController!]
    }

}
