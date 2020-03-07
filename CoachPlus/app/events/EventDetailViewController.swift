//
//  EventDetailViewController.swift
//  CoachPlus
//
//  Created by Maurice Breit on 17.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit

class EventDetailViewController: CoachPlusViewController, UITableViewDelegate, UITableViewDataSource, TableHeaderViewButtonDelegate, NewNewsDelegate, ParticipationTableViewCellDelegate, EventDetailCellReminderDelegate, EventDetailCellDeleteDelegate, CreateEventViewControllerDelegate {
    
    func eventCreated() {
        return
    }
    
    func eventChanged(newEvent: Event) {
        self.gotNewEvent(event: newEvent)
    }
    
    func eventDeleted() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    enum Section:Int {
        case general = 0
        case news = 1
        case participation = 2
    }
    
    var event:Event?
    var news = [News]()
    var participationItems = [ParticipationItem]()
    
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //self.view.heroID = self.heroId
        
        self.tableView.register(nib: "ParticipationTableViewCell", reuseIdentifier: "ParticipationTableViewCell")
        self.tableView.register(nib: "NewsTableViewCell", reuseIdentifier: "NewsTableViewCell")
        self.tableView.register(nib: "EventDetailCell", reuseIdentifier: "EventDetailCell")
        self.tableView.register(nib: "BannerTableViewCell", reuseIdentifier: "BannerTableViewCell")
        
        let nib = UINib(nibName: "ReusableTableHeader", bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableHeader")
        
        let pNib = UINib(nibName: "ReusableParticipationHeaderView", bundle: nil)
        self.tableView.register(pNib, forHeaderFooterViewReuseIdentifier: "ReusableParticipationHeaderView")
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 70
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        self.gotNewEvent(event: self.event!)
    }
    
    @objc private func refresh(_ sender: Any) {
        
        guard self.event != nil else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.loadData(text: nil, promise: DataHandler.def.getEvent(teamId: event!.teamId, eventId: event!.id)).done({ event in
            self.gotNewEvent(event: event)
        })
        
    }
    
    func gotNewEvent(event: Event) {
        self.event = event
        self.loadParticipations()
        self.loadNews()
        self.tableView.reloadData()
        self.navigationItem.title = self.event?.name
        
        self.refreshControl.endRefreshing()
    }
    
    func loadParticipations() {
        DataHandler.def.getParticipations(event: self.event!).done({ participationItems in
            self.participationItems = participationItems
            self.tableView.reloadData()
        }).catch({ err in
            print(err)
        });
    }
    
    func loadNews() {
        DataHandler.def.getNews(event: self.event!).done({ news in
            self.news = news
            self.tableView.reloadData()
        }).catch({ err in
            print(err)
        });
    }
    
    func hasNews() -> Bool {
        return self.news.count > 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func getSectionType(section:Int) -> Section {
        return Section(rawValue: section)!
    }
    
    func showHeaderRow() -> Bool {
        return ((event!.startedInPast() && self.userIsCoach()) || (self.participationItems.count > 0 && event!.startedInPast() == false))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = self.getSectionType(section: section)
        switch sectionType {
        case .general:
            return 1
        case .news:
            if (!self.hasNews()) {
                return 1
            }
            return self.news.count
        case .participation:
            if (self.showHeaderRow()) {
                return self.participationItems.count + 1
            }
            return self.participationItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch getSectionType(section: indexPath.section) {
        case .general:
            return self.generalCell(indexPath: indexPath)
        case .news:
            return self.newsCell(indexPath: indexPath)
        case .participation:
            if (self.showHeaderRow()) {
                if (indexPath.row == 0) {
                    return self.bannerCell(indexPath: indexPath)
                } else {
                    return self.participationCell(indexPath: indexPath)
                }
            } else {
                return self.participationCell(indexPath: indexPath)
            }
        }
    }
    
    func bannerCell(indexPath: IndexPath) -> BannerTableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell", for: indexPath) as! BannerTableViewCell
        
        var text = L10n.pleaseSetParticipation
        var bgColor = UIColor.coachPlusBannerBackgroundColor
        var textColor = UIColor.coachPlusBlue
        
        if (self.userIsCoach() && event!.startedInPast()) {
            text = L10n.youCanNowSelectWhoParticipated
            textColor = UIColor.coachPlusBlue
        }
        
        cell.configure(text: text, bgColor: bgColor, textColor: textColor)
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        
        return cell
    }
    
    func participationCell(indexPath:IndexPath) -> ParticipationTableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ParticipationTableViewCell", for: indexPath) as! ParticipationTableViewCell
        var row = indexPath.row
        if (self.showHeaderRow()) {
            row = row - 1
        }
        let participationItem = self.participationItems[row]
        cell.configure(delegate: self, participationItem: participationItem, event: self.event!)
        return cell
    }
    
    func newsCell(indexPath:IndexPath) -> UITableViewCell {
        if (!self.hasNews()) {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "DefaultCell")
            cell.textLabel?.text = L10n.noNews
            return cell
        }
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        let news = self.news[indexPath.row]
        cell.configure(news: news)
        return cell
    }
    
    func generalCell(indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "EventDetailCell", for: indexPath) as! EventDetailCell
        cell.configure(event: self.event!, team: self.membership!.team!, isCoach: self.membership?.isCoach(), vc: self)
        cell.reminderDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let sectionType = getSectionType(section: section)
        
        switch sectionType {
        case .news:
            let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableHeader")
            let view = cell as! ReusableTableHeader
            
            if  (self.userIsCoach()) {
                
                view.tableHeader.btn.tag = Section.news.rawValue
                view.tableHeader.delegate = self
                view.tableHeader.showBtn = true
                
            } else {
                view.tableHeader.showBtn = false
            }
            
            view.tableHeader.title = L10n.news
            
            return view
        case .participation:
            let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "ReusableParticipationHeaderView")
            let view = cell as! ReusableParticipationHeaderView
            
            view.tableHeader.setTitle(title: L10n.participation)
        
            view.tableHeader.eventIsInPast = self.event!.isInPast()
            view.tableHeader.setLabels(participations: self.participationItems)
            
            return view
            
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionType = getSectionType(section: section)
        switch sectionType {
        case .general:
            return 0
        default:
            return 45
        }
    }
    
    func tableViewHeaderBtnTap(_ sender: Any) {
        
        let section = Section(rawValue: (sender as AnyObject).tag)
        
        guard (section != nil) else {
            return
        }
        
        if (section == .news) {
            self.newNews()
        }
    }
    
    func newNews() {
        let vc = UIStoryboard(name: "NewNews", bundle: nil).instantiateInitialViewController() as! NewNewsViewController
        vc.delegate = self
        vc.event = self.event
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func newsCreated() {
        self.loadNews()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let sectionType = self.getSectionType(section: indexPath.section)
        if (sectionType == .news && (self.membership?.isCoach())!) {
            let delete = UITableViewRowAction(style: .destructive, title: L10n.delete) { (action, indexPath) in
                self.deleteNews(indexPath: indexPath)
            }
            return [delete]
        }
        return []
    }
    
    func deleteNews(indexPath:IndexPath) {
        guard indexPath.row < self.news.count else {
            return
        }
        
        let news = self.news[indexPath.row]
        
        DataHandler.def.deleteNews(teamId: (self.event?.teamId)!, news: news).done({ response in
            if (self.news.count > 1) {
                self.news.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            self.loadNews()
        }).catch({ err in
            
        })
        
    }
    
    func participationChanged() {
        if let headerView = self.tableView.headerView(forSection: Section.participation.rawValue) as? ReusableParticipationHeaderView {
            headerView.tableHeader.refresh()
        }
    }
    
    func delete(event: Event) {
        if let delegate = self.previousVC as? EventDetailCellDeleteDelegate {
            delegate.delete(event: self.event!)
        }
    }
    
    func userIsCoach() -> Bool {
        return (self.membership?.team?.id == self.event?.teamId && (self.membership?.isCoach())!)
    }
    
    func sendReminder(event: Event) {
        self.loadData(text: nil, promise: DataHandler.def.sendReminder(teamId: self.event!.teamId, eventId: self.event!.id)).done({_ in
            DropdownAlert.success(message: L10n.theReminderWasSentSuccessfully)
        })
    }
}
