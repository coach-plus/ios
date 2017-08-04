//
//  EventDetailViewController.swift
//  CoachPlus
//
//  Created by Maurice Breit on 17.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit

class EventDetailViewController: CoachPlusViewController, UITableViewDelegate, UITableViewDataSource, TableHeaderViewButtonDelegate, NewNewsDelegate {
    
    enum Section:Int {
        case news = 0
        case participation = 1
    }

    
    var event:Event?
    var news = [News]()
    var participationItems = [ParticipationItem]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UITextView!
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var editBtn: UIButton!
    
    @IBAction func editBtnTapped(_ sender: Any) {
    }
    
    
    
    override func viewDidLoad() {
        
        self.view.heroID = self.heroId
        
        self.nameLbl.heroID = "\(self.heroId)/name"
        
        self.tableView.register(nib: "ParticipationTableViewCell", reuseIdentifier: "ParticipationTableViewCell")
        self.tableView.register(nib: "NewsTableViewCell", reuseIdentifier: "NewsTableViewCell")
        
        let nib = UINib(nibName: "ReusableTableHeader", bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableHeader")
        
        self.editBtn.setIcon(icon: .googleMaterialDesign(.modeEdit), iconSize: 20, color: .coachPlusLightGrey, backgroundColor: .clear, forState: .normal)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
        super.viewDidLoad()
        self.descriptionLbl.fixPadding()
        self.loadParticipations()
        self.loadNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.nameLbl.text = self.event?.name
        self.dateTimeLbl.text = self.event?.fromToString()
        self.locationLbl.text = "location"
        
        var description = ""
        if (event?.description != "") {
            description = (event?.description)!
        } else {
            description = "keine Beschreibung vorhanden"
        }
        self.descriptionLbl.text = description
        
        if (self.membership?.isCoach())! {
            self.editBtn.isHidden = false
        }
        
        self.locationLbl.text = self.event?.getLocationString()
        
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
    
    func loadNews() {
        _ = DataHandler.def.getNews(event: self.event!, successHandler: { news in
            self.news = news
            self.tableView.reloadData()
        }, failHandler: { err in
            print(err)
        });
    }
    
    func hasNews() -> Bool {
        return self.news.count > 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func getSectionType(section:Int) -> Section {
        return Section(rawValue: section)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = self.getSectionType(section: section)
        switch sectionType {
        case .news:
            if (!self.hasNews()) {
                return 1
            }
            return self.news.count
        case .participation:
            return self.participationItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch getSectionType(section: indexPath.section) {
        case .news:
            return self.newsCell(indexPath: indexPath)
        case .participation:
            return self.participationCell(indexPath: indexPath)
        }
    }
    
    func participationCell(indexPath:IndexPath) -> ParticipationTableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ParticipationTableViewCell", for: indexPath) as! ParticipationTableViewCell
        let participationItem = self.participationItems[indexPath.row]
        cell.configure(participationItem: participationItem, event: self.event!)
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableHeader")
        let view = cell as! ReusableTableHeader
        
        let sectionType = getSectionType(section: section)
        
        if  (self.membership?.team?.id == self.event?.teamId &&
            (self.membership?.isCoach())! &&
            sectionType == Section.news) {
            
            view.tableHeader.btn.tag = Section.news.rawValue
            view.tableHeader.delegate = self
            view.tableHeader.showBtn = true
            
        } else {
            view.tableHeader.showBtn = false
        }
        
        switch sectionType {
        case .participation:
            view.tableHeader.title = "TEILNAHME"
        case .news:
            view.tableHeader.title = "NEWS"
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
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
        
        DataHandler.def.deleteNews(teamId: (self.event?.teamId)!, news: news, successHandler: { response in
            if (self.news.count > 1) {
                self.news.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            self.loadNews()
        }, failHandler: { err in
            
        })
        
        
    }
}
