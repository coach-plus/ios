//
//  NewNewsViewController.swift
//  CoachPlus
//
//  Created by Maurice Breit on 04.08.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

protocol NewNewsDelegate {
    func newsCreated()
}

class NewNewsViewController: CoachPlusViewController {
    
    @IBOutlet weak var createBtn: OutlineButton!
    
    @IBOutlet weak var tableHeaderView: TableHeaderView!
    
    @IBOutlet weak var titleTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var messageTf: SkyFloatingLabelTextField!
    
    @IBAction func btnTap(_ sender: Any) {
        self.createNews()
    }
    
    var delegate: NewNewsDelegate?
    var event:Event?
    
    override func viewDidLoad() {
        self.titleTf.placeholder = "NEWS_TITLE".localize()
        self.messageTf.placeholder = "NEWS_MESSAGE".localize()
        self.tableHeaderView.title = "NEWS_CREATE_HEADER".localize()
        self.createBtn.setTitle("NEWS_CREATE_HEADER".localize(), for: .normal)
    }
    
    func createNews() {
        
        let title = self.titleTf.text
        let message = self.messageTf.text
        
        guard title != nil || message != nil else {
            return
        }
        
        let createNews = [
            "title": title,
            "text": message
        ]
        
        self.loadData(text: "CREATE_NEWS", promise: DataHandler.def.createNews(event: self.event!, createNews: createNews)).done({ response in
            if self.delegate != nil {
                self.delegate!.newsCreated()
            }
            self.navigationController?.popViewController(animated: true)
        }).catch({ err in
            print(err)
        })
        
    }
    
    
    
}
