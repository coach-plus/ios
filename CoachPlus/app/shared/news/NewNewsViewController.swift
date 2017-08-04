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
    
    @IBOutlet weak var titleTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var messageTf: SkyFloatingLabelTextField!
    
    @IBAction func btnTap(_ sender: Any) {
        self.createNews()
    }
    
    var delegate: NewNewsDelegate?
    var event:Event?
    
    
    
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
        
        DataHandler.def.createNews(event: self.event!, createNews: createNews, successHandler: { response in
            if self.delegate != nil {
                self.delegate!.newsCreated()
            }
            self.navigationController?.popViewController(animated: true)
        }, failHandler: { error in
            print(error)
        })
        
    }
    
    
    
}
