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
import PromiseKit
import MBProgressHUD

extension UIViewController {
    
    func setSeparator(tableView:UITableView, toCheck:[Any]?) {
        if (toCheck != nil && toCheck!.count > 0) {
            tableView.separatorStyle = .singleLine
        } else {
            tableView.separatorStyle = .none
        }
    }
    
    func enableDrawer(){
        FlowManager.getDrawerController()?.openDrawerGestureModeMask = MMOpenDrawerGestureMode.bezelPanningCenterView
    }
    
    func disableDrawer() {
        FlowManager.getDrawerController()?.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningNavigationBar
    }
    
    func openWebpage(urlString:String) {
        let url = URL(string: urlString)!
        let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
        present(vc, animated: true, completion: nil)
    }
    
    func showConfirmation(title: String, message: String, yes: String, no: String, yesStyle: UIAlertAction.Style, noStyle: UIAlertAction.Style, yesHandler: ((UIAlertAction) -> Void)? = nil, noHandler: ((UIAlertAction) -> Void)? = nil, style: UIAlertController.Style = UIAlertController.Style.actionSheet, showCancelButton: Bool?) {
        let alertController = UIAlertController(title: title.localize(), message: message.localize(), preferredStyle: style)
        
        let yesButton = UIAlertAction(title: yes.localize(), style: yesStyle, handler: yesHandler)
        
        let noButton = UIAlertAction(title: no.localize(), style: noStyle, handler: noHandler)
        
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
        }
        
        alertController.addAction(yesButton)
        alertController.addAction(noButton)
        
        if (showCancelButton == true) {
            let cancelButton = UIAlertAction(title: "CANCEL".localize(), style: .cancel, handler: nil)
            alertController.addAction(cancelButton)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func handleApiError(apiError: ApiError) {
        DropdownAlert.error(message: apiError.message)
    }
    
    func handleGeneralError(error: Error) {
        DropdownAlert.error(message: error.localizedDescription)
    }
    
}
