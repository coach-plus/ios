//
//  NewsTableViewCell.swift
//  CoachPlus
//
//  Created by Maurice Breit on 04.08.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var descriptionTv: UITextView!
    @IBOutlet weak var authorLbl: UILabel!
    
    var news:News?
    
    func configure(news:News) {
        self.news = news
        self.titleLbl.text = news.title
        self.imageV.setUserImage(user: news.author!)
        self.descriptionTv.text = news.text
        self.descriptionTv.fixPadding()
        self.authorLbl.text = "\(news.author!.fullname) - \(news.dateTimeString())"
    }
    
}
