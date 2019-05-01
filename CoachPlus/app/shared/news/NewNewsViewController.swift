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
    
    @IBOutlet weak var messageTf: SkyFloatingLabelTextField!
    
    @IBAction func btnTap(_ sender: Any) {
        self.createNews()
    }
    
    var delegate: NewNewsDelegate?
    var event:Event?
    
    override func viewDidLoad() {
        self.messageTf.placeholder = L10n.message
        self.tableHeaderView.title = L10n.newNews
        self.createBtn.setTitle(L10n.newNews, for: .normal)
    }
    
    func createNews() {
        
        let message = self.messageTf.text
        
        guard message != nil else {
            return
        }
        
        let createNews = [
            "title": "",
            "text": message
        ]
        
        self.loadData(text: L10n.loading, promise: DataHandler.def.createNews(event: self.event!, createNews: createNews)).done({ response in
            if self.delegate != nil {
                self.delegate!.newsCreated()
            }
            self.navigationController?.popViewController(animated: true)
        }).catch({ err in
            print(err)
        })
        
    }
    
    
    
}
