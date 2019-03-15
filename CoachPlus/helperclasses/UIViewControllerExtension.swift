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
    
    func loadData<T>(text: String?, promise: Promise<T>) -> Promise<T> {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.detailsLabel.text = text?.localize()
        
        return promise.map({ result in
            return result
        }).ensure {
            hud.hide(animated: true)
        }
    }
    
    func showConfirmation(title: String, message: String, yes: String, no: String, yesStyle: UIAlertAction.Style, noStyle: UIAlertAction.Style, yesHandler: ((UIAlertAction) -> Void)? = nil, noHandler: ((UIAlertAction) -> Void)? = nil, style: UIAlertController.Style = UIAlertController.Style.actionSheet) {
        let alertController = UIAlertController(title: title.localize(), message: message.localize(), preferredStyle: style)
        
        let yesButton = UIAlertAction(title: yes.localize(), style: yesStyle, handler: yesHandler)
        
        let noButton = UIAlertAction(title: no.localize(), style: noStyle, handler: noHandler)
        
        let cancelButton = UIAlertAction(title: "CANCEL".localize(), style: .cancel, handler: nil)
        
        alertController.addAction(yesButton)
        alertController.addAction(noButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
