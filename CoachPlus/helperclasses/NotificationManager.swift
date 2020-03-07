//
//  NotificationManager.swift
//  CoachPlus
//
//  Created by Maurice Breit on 05.08.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import PromiseKit

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = NotificationManager()
    
    var teamVc: UIViewController?
    var currentVc: CoachPlusViewController?
    var isGrantedAccess:Bool = false
    
    enum NotificationCategory:String {
        case EventReminder = "EVENT_REMINDER"
        case News = "NEWS"
    }
    
    enum NotificationAction:String {
        case eventReminderWillAttend = "EVENT_REMINDER-WILL_ATTEND"
        case eventReminderWillNotAttend = "EVENT_REMINDER-WILL_NOT_ATTEND"
    }
    
    func setTeamVc(teamVc:UIViewController) {
        self.teamVc = teamVc
        UNUserNotificationCenter.current().delegate = self
    }
    
    func setCurrentVc(currentVc: CoachPlusViewController) {
        self.currentVc = currentVc
    }
    
    func registerForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert,.sound,.badge],
            completionHandler: { (granted,error) in
                self.isGrantedAccess = granted
                if granted {
                    print("Notifications allowed")
                    self.setUpCategories()
                    self.registerForRemote()
                } else {
                    /*
                    let alert = UIAlertController(title: "Notification Access", message: "In order to use this application, turn on notification permissions.", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                    alert.addAction(alertAction)
                    self.currentVc?.presentModally(alert , animated: true, completion: nil)
                    */
                }
        })
    }
    
    func registerForRemote() {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    static func registerDeviceOnServer(pushId:String) {
        
        
        let p = DataHandler.def.registerDevice(pushId: pushId)
        
        if (p != nil) {
            p?.done({ res in
                print("Device registered successfully")
            }).catch({err in
                print("Device could not be registered")
            })
        }
    }
    
    func setUpCategories() {
        let setWillAttendAction = UNNotificationAction(identifier: NotificationAction.eventReminderWillAttend.rawValue, title: L10n.participateYes, options: [.authenticationRequired])
        let setWillNotAttendAction = UNNotificationAction(identifier: NotificationAction.eventReminderWillNotAttend.rawValue, title: L10n.participateNo, options: [.authenticationRequired, .destructive])
        
        let newEventCategory = UNNotificationCategory(identifier: NotificationCategory.EventReminder.rawValue, actions: [setWillAttendAction, setWillNotAttendAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([newEventCategory])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        guard Authentication.loggedIn() else {
            return
        }
        
        
        
        switch response.actionIdentifier {
        case NotificationAction.eventReminderWillAttend.rawValue, NotificationAction.eventReminderWillNotAttend.rawValue:
            let values = response.notification.request.content.userInfo
            if let eventId = values["eventId"] as? String,
                let teamId = values["teamId"] as? String {
                    let willAttend = (response.actionIdentifier == NotificationAction.eventReminderWillAttend.rawValue)
                    DataHandler.def.willAttend(teamId: teamId, eventId: eventId, userId: Authentication.getUser().id, willAttend: willAttend).done({ res in
                    completionHandler()
                }).catch({err in
                    completionHandler()
                })
            } else {
                completionHandler()
            }
        default:
            self.handleNotification(userInfo: response.notification.request.content.userInfo)
            completionHandler()
        }
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    func handleNotification(userInfo: [AnyHashable: Any]) {
        
        let aps = userInfo["aps"] as! [AnyHashable: Any]
        let category = aps["category"] as! String
        
        let teamId = userInfo["teamId"] as! String
        let eventId = userInfo["eventId"] as! String
        let membership = MembershipManager.shared.getMembershipFromLocalMemberships(teamId: teamId)
        
        if (membership != nil) {
            switch category {
            case NotificationCategory.EventReminder.rawValue,
                 NotificationCategory.News.rawValue:
                MembershipManager.shared.setSelectedMembership(membership: membership)
                currentVc?.loadData(text: nil, promise: DataHandler.def.getEvent(teamId: teamId, eventId: eventId)).done({ event in
                    self.currentVc!.pushToEventDetail(currentVC: self.currentVc!, event: event)
                })
                break
            default:
                break
            }
        }
    }
    
    
}
