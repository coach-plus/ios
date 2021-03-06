//
//  AppDelegate.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 21.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import UIKit
import UserNotifications
import IQKeyboardManagerSwift
import Hero
import Sentry
import YPImagePicker

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
        self.setupSentry()
        
        self.setupStyling()
        
        if (Authentication.loggedIn() == false) {
            FlowManager.setLogin()
            return true
        } else {
            FlowManager.setHome()
            NotificationManager.shared.registerForNotifications()
        }
        
        DataHandler.def.getUser().done({user in
            UserManager.storeUser(user: user)
            UserManager.shared.userWasEdited.onNext(user)
        }).catch({error in
            print("could not get user")
        })

        UNUserNotificationCenter.current().delegate = NotificationManager.shared
        
        return true
    }
    
    func setupSentry() {
        // Create a Sentry client and start crash handler
        do {
            Client.shared = try Client(dsn: "https://4baa82fe6831479993ff4a6b73ec4a59@sentry.io/1533813")
            try Client.shared?.startCrashHandler()
        } catch let error {
            print("\(error)")
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    //Styling
    
    
    func setupStyling() {
        Hero.shared.containerColor = .clear
        self.window?.backgroundColor = .coachPlusBlue
        //let ai = UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self])
        //ai.color = UIColor.coachPlusBlue
        
        //UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().backgroundColor = .coachPlusBlue
        
        UITableViewCell.appearance().backgroundColor = UIColor.defaultBackground
        
        UITableView.appearance().backgroundColor = UIColor.defaultBackground
        
        let pickerAppearrance = UINavigationBar.appearance(whenContainedInInstancesOf: [YPImagePicker.self])
        pickerAppearrance.tintColor = .coachPlusBlue
    }
    
    
    
    // Push Notifications

    
    // Called when APNs has assigned the device a unique token
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        if (!Authentication.loggedIn()) {
            return
        }
        
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let deviceTokenString = tokenParts.joined()
        
        print("APNs device token: \(deviceTokenString)")
        NotificationManager.registerDeviceOnServer(pushId: deviceTokenString)
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        print("Push notification received: \(data)")
    }
    
    
    
    
    // Universal Link
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // 1
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                return false
        }
        
        print(url)
        
        
        return UrlHandler.handleUrlComponents(components: components)
    }
    
    /*
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        // 1
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                return false
        }
        
        print(url)
        
        
        return UrlHandler.handleUrlComponents(components: components)
        
    }
 */
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        return true
    }
}

