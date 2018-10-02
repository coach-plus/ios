//
//  UIViewControllerExtension.swift
//  CoachPlus
//
//  Created by Maurice Breit on 16.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit
import MMDrawerController
import SafariServices

extension UIViewController {
    
    func setSeparator(tableView:UITableView, toCheck:[Any]?) {
        if (toCheck != nil && toCheck!.count > 0) {
            tableView.separatorStyle = .singleLine
        } else {
            tableView.separatorStyle = .none
        }
    }
    
    func enableDrawer(){
        FlowManager.getDrawerController().openDrawerGestureModeMask = MMOpenDrawerGestureMode.bezelPanningCenterView
    }
    
    func disableDrawer() {
        FlowManager.getDrawerController().openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningNavigationBar
    }
    
    func openWebpage(urlString:String) {
        let url = URL(string: urlString)!
        let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
        present(vc, animated: true, completion: nil)
    }
    
}
