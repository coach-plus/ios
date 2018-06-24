//
//  UIViewControllerExtension.swift
//  CoachPlus
//
//  Created by Maurice Breit on 16.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit

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
    
}
