//
//  CoachPlusViewController.swift
//  CoachPlus
//
//  Created by Maurice Breit on 16.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import RxSwift
import PromiseKit
import MBProgressHUD

class CoachPlusViewController: UIViewController, ErrorHandlerDelegate {
    
    var loaded = false
    
    var membership:Membership?
    
    var previousVC: CoachPlusViewController?

    var heroId:String = ""
    
    var errorHandler: ErrorHandler?
    
    public let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.errorHandler = ErrorHandler(delegate: self)
        
        setNeedsStatusBarAppearanceUpdate()
        
        self.isHeroEnabled = true
        
        if (self.membership == nil) {
            self.membership = MembershipManager.shared.getPreviouslySelectedMembership()
        }
        
        self.view.backgroundColor = UIColor.coachPlusBlue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupNavBarDelegate()
        self.disableDrawer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupNavBarDelegate() {
        if let navbar = self.navigationController?.navigationBar as? CoachPlusNavigationBar {
            navbar.coachPlusNavigationBarDelegate = self as? CoachPlusNavigationBarDelegate
        }
    }
    
    func pushToEventDetail(currentVC: CoachPlusViewController, event:Event) {
        let targetVc = UIStoryboard(name: "EventDetail", bundle: nil).instantiateInitialViewController() as! EventDetailViewController
        targetVc.event = event
        targetVc.heroId = "event\(event.id)"
        targetVc.isHeroEnabled = true
        targetVc.previousVC = currentVC
        self.navigationController?.pushViewController(targetVc, animated: true)
    }
    
    func setLeftBarButton(type:CoachPlusNavigationBar.BarButtonType) {
        if let navbar = self.navigationController?.navigationBar as? CoachPlusNavigationBar {
            navbar.leftBarButtonType = type
            navbar.setLeftBarButton(item: self.navigationItem)
        }
    }
    
    func setRightBarButton(type:CoachPlusNavigationBar.BarButtonType) {
        if let navbar = self.navigationController?.navigationBar as? CoachPlusNavigationBar {
            navbar.rightBarButtonType = type
            navbar.setRightBarButton(item: self.navigationItem)
        }
    }
    
    func setNavbarTitle() {
        if (self.membership != nil) {
            self.navigationItem.titleView = nil
            self.setNavbarTitle(title: self.membership?.team?.name)
        } else {
            self.setCoachPlusLogo()
        }
    }
    
    func setNavbarTitle(title: String?) {
        if (title != nil) {
            self.navigationController?.navigationBar.topItem?.title = title
        }
    }
    
    func setCoachPlusLogo() {
        let topItem = self.navigationItem
        let img = UIImageView(image: UIImage(named: "LogoWhite"))
        img.contentMode = .scaleAspectFit
        
        let title = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 45))
        img.frame = title.bounds
        title.addSubview(img)
        topItem.titleView = title
    }
    
    func loadData<T>(text: String?, promise: Promise<T>) -> Promise<T> {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.detailsLabel.text = text?.localize()
        
        return Promise { p in
            promise.done({ result in
                p.fulfill(result)
            }).ensure({
                hud.hide(animated: true)
            }).catch({err in
                self.errorHandler?.handleError(error: err)
                p.reject(err)
            })
        }
    }

}
