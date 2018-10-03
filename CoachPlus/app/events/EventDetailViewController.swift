//
//  EventDetailViewController.swift
//  CoachPlus
//
//  Created by Maurice Breit on 17.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit

class EventDetailViewController: CoachPlusViewController, UITableViewDelegate, UITableViewDataSource, TableHeaderViewButtonDelegate, NewNewsDelegate, ParticipationTableViewCellDelegate, EventDetailCellActions {
    
    enum Section:Int {
        case general = 0
        case news = 1
        case participation = 2
    }
    
    var event:Event?
    var news = [News]()
    var participationItems = [ParticipationItem]()
    
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
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
        
        self.loadParticipations()
        self.loadNews()
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
            if (self.participationItems.count > 0) {
                return self.participationItems.count + 1
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch getSectionType(section: indexPath.section) {
        case .general:
            return self.generalCell(indexPath: indexPath)
        case .news:
            return self.newsCell(indexPath: indexPath)
        case .participation:
            if (indexPath.row == 0) {
                return self.bannerCell(indexPath: indexPath)
            } else {
                return self.participationCell(indexPath: indexPath)
            }
        }
    }
    
    func bannerCell(indexPath: IndexPath) -> BannerTableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell", for: indexPath) as! BannerTableViewCell
        
        var text = "MAINTAIN_WILL"
        var bgColor = UIColor.coachPlusBannerBackgroundColor
        var textColor = UIColor.coachPlusBlue
        
        if (self.userIsCoach() && event!.startedInPast()) {
            text = "MAINTAIN_DID"
            textColor = UIColor.coachPlusParticipationNoColor
        }
        
        
        cell.configure(text: text.localize(), bgColor: bgColor, textColor: textColor)
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        
        return cell
    }
    
    func participationCell(indexPath:IndexPath) -> ParticipationTableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ParticipationTableViewCell", for: indexPath) as! ParticipationTableViewCell
        let participationItem = self.participationItems[indexPath.row - 1]
        cell.configure(delegate: self, participationItem: participationItem, event: self.event!)
        return cell
    }
    
    func newsCell(indexPath:IndexPath) -> UITableViewCell {
        if (!self.hasNews()) {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "DefaultCell")
            cell.textLabel?.text = "No News"
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
            
            view.tableHeader.title = "NEWS".localize()
            
            return view
        case .participation:
            let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "ReusableParticipationHeaderView")
            let view = cell as! ReusableParticipationHeaderView
            
            view.tableHeader.setTitle(title: "PARTICIPATION".localize())
        
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
        print("new News")
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
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
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
        if let delegate = self.previousVC as? EventDetailCellActions {
            delegate.delete(event: self.event!)
        }
    }
    
    func userIsCoach() -> Bool {
        return (self.membership?.team?.id == self.event?.teamId && (self.membership?.isCoach())!)
    }
}
