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


class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    var vc:UIViewController?
    var isGrantedAccess:Bool = false
    
    enum NotificationCategory:String {
        case EventReminder = "EVENT_REMINDER"
        case NewAnnouncement = "NEW_ANNOUNCEMENT"
    }
    
    enum NotificationAction:String {
        case eventReminderWillAttend = "EVENT_REMINDER-WILL_ATTEND"
        case eventReminderWillNotAttend = "EVENT_REMINDER-WILL_NOT_ATTEND"
    }
    
    
    init(vc:UIViewController) {
        super.init()
        self.vc = vc
        UNUserNotificationCenter.current().delegate = self
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
                    let alert = UIAlertController(title: "Notification Access", message: "In order to use this application, turn on notification permissions.", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                    alert.addAction(alertAction)
                    self.vc?.present(alert , animated: true, completion: nil)
                }
        })
    }
    
    func registerForRemote() {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    static func registerDeviceOnServer(pushId:String) {
        _ = DataHandler.def.registerDevice(pushId: pushId, successHandler: { res in
            print("Device registered successfully")
        }, failHandler: {err in
            print("Device could not be registered")
        })
    }
    
    func setUpCategories() {
        let setWillAttendAction = UNNotificationAction(identifier: NotificationAction.eventReminderWillAttend.rawValue, title: "Zusagen", options: [.authenticationRequired])
        let setWillNotAttendAction = UNNotificationAction(identifier: NotificationAction.eventReminderWillNotAttend.rawValue, title: "Absagen", options: [.authenticationRequired, .destructive])
        
        let newEventCategory = UNNotificationCategory(identifier: NotificationCategory.EventReminder.rawValue, actions: [setWillAttendAction, setWillNotAttendAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([newEventCategory])
        print("Categories are set up")
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
                    _ = DataHandler.def.willAttend(teamId: teamId, eventId: eventId, userId: Authentication.getUser().id, willAttend: willAttend, successHandler: { res in
                    completionHandler()
                }, failHandler: {err in
                    completionHandler()
                })
            } else {
                completionHandler()
            }
        default:
            print("Other Action")
            completionHandler()
        }
        
        
    }
    
    
    
}
