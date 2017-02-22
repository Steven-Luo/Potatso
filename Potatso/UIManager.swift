//
//  UIManager.swift
//  Potatso
//
//  Created by LEI on 12/27/15.
//  Copyright © 2015 TouchingApp. All rights reserved.
//

import Foundation
import ICSMainFramework
import PotatsoLibrary
import Aspects
import Firebase
import FirebaseMessaging
import FirebaseInstanceID

class UIManager: NSObject, AppLifeCycleProtocol {
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    static var sharedInstance: UIManager?
    static let firstActionId = "FIRST_ACTION"
    static let secondActionId = "SECOND_ACTION"
    static let thirdActionId = "THIRD_ACTION"
    
    static let firstCategoryId = "FIRST_CATEGORY"

    override init() {
        super.init()
        UIManager.sharedInstance = self
    }
    
    var keyWindow: UIWindow? {
        return UIApplication.sharedApplication().keyWindow
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        let token = UserService.sharedInstance.getToken()
        
        if let _ = token.value, expireDate = token.expireDate
            where expireDate.compare(NSDate()) == NSComparisonResult.OrderedDescending {
            keyWindow?.rootViewController = getMainViewController()
        } else {
            let loginViewController = LoginViewController()
            keyWindow?.rootViewController = loginViewController
        }
        keyWindow?.makeKeyAndVisible()
        
        registerRemoteNotification(application)
        return true
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        let refreshedToken = FIRInstanceID.instanceID().token()
        print("InstanceID token: \(refreshedToken)")
        WiFiPasswordService.instance.uploadToken(refreshedToken)
        
        connectToFcm()
    }
    
    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion(){ (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    func registerRemoteNotification(application: UIApplication) {
//        let firstAction: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
//        firstAction.identifier = UIManager.firstActionId
//        firstAction.title = "Background Action"
//        firstAction.activationMode = UIUserNotificationActivationMode.Background
//        firstAction.destructive = true
//        firstAction.authenticationRequired = true
//        
//        let secondAction: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
//        secondAction.identifier = UIManager.secondActionId
//        secondAction.activationMode = .Foreground
//        secondAction.title = "Second Action"
//        secondAction.authenticationRequired = false
//        
//        let thirdAction: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
//        thirdAction.identifier = UIManager.thirdActionId
//        thirdAction.activationMode = .Background
//        thirdAction.title = "Third Action"
//        thirdAction.authenticationRequired = false
//        
//        let firstCategory = UIMutableUserNotificationCategory()
//        firstCategory.identifier = UIManager.firstCategoryId
//        
//        let defaultAction = [firstAction, secondAction, thirdAction]
//        let minimalAction = [firstAction, secondAction]
//        
//        firstCategory.setActions(defaultAction, forContext: .Default)
//        firstCategory.setActions(minimalAction, forContext: .Minimal)
//        
//        let categorySet: Set<UIUserNotificationCategory> = Set<UIUserNotificationCategory>(arrayLiteral: firstCategory)
        //        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
        //                let notificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categorySet)
        //        let notificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: (NSSet(array: [firstCategory])) as? Set<UIUserNotificationCategory>)
        
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
        let notificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        application.registerForRemoteNotifications()
        application.registerUserNotificationSettings(notificationSettings)

//        FIRApp.configure()
//        connectToFcm()
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(tokenRefreshNotification(_:)),
//                                                                 name: kFIRInstanceIDTokenRefreshNotification,
//                                                                 object: nil)
//        
//        let token = FIRInstanceID.instanceID().token()
//        print("connect to fcm ======================================================")
//        print(token)
//        WiFiPasswordService.instance.uploadToken(token)
    }
    
    func showMainViewController() {
        UIView.appearance().tintColor = Color.Brand
        
        UITableView.appearance().backgroundColor = Color.Background
        UITableView.appearance().separatorColor = Color.Separator
        
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barTintColor = Color.NavigationBackground
        
        UITabBar.appearance().translucent = false
        UITabBar.appearance().backgroundColor = Color.TabBackground
        UITabBar.appearance().tintColor = Color.TabItemSelected
        
        keyWindow?.rootViewController = makeRootViewController()
        
        Receipt.shared.validate()
    }
    
    func getMainViewController() -> UIViewController {
        UIView.appearance().tintColor = Color.Brand
        
        UITableView.appearance().backgroundColor = Color.Background
        UITableView.appearance().separatorColor = Color.Separator
        
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barTintColor = Color.NavigationBackground
        
        UITabBar.appearance().translucent = false
        UITabBar.appearance().backgroundColor = Color.TabBackground
        UITabBar.appearance().tintColor = Color.TabItemSelected
        
        Receipt.shared.validate()
        
        return makeRootViewController()
    }
    
    func makeRootViewController() -> UITabBarController {
        let tabBarVC = UITabBarController()
        tabBarVC.viewControllers = makeChildViewControllers()
        tabBarVC.selectedIndex = 0
        return tabBarVC
    }
    
    func makeChildViewControllers() -> [UIViewController] {
        let cons: [(UIViewController.Type, String, String)] = [(HomeVC.self, "Home".localized(), "Home"), (DashboardVC.self, "Statistics".localized(), "Dashboard")/*, (CollectionViewController.self, "Manage".localized(), "Config")*/, (MineViewController.self, "Mine".localized(), "User2")]
        return cons.map {
            let vc = UINavigationController(rootViewController: $0.init())
            vc.tabBarItem = UITabBarItem(title: $1, image: $2.originalImage, selectedImage: $2.templateImage)
            return vc
        }
    }
}
