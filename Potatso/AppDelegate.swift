//
//  AppDelegate.swift
//  Potatso
//
//  Created by LEI on 12/12/15.
//  Copyright © 2015 TouchingApp. All rights reserved.
//

import UIKit
import ICSMainFramework

@UIApplicationMain
public class AppDelegate: ICSMainFramework.ICSAppDelegate {
    public func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        if shortcutItem.type == "com.gudatech.abestproxy" {
            let token = UserService.sharedInstance.getToken()
            
            if let _ = token.value, expireDate = token.expireDate, mainViewController = UIManager.sharedInstance?.getMainViewController()
                where expireDate.compare(NSDate()) == NSComparisonResult.OrderedDescending {
                let root = UIApplication.sharedApplication().keyWindow?.rootViewController
                root?.presentViewController(mainViewController, animated: true, completion: {
                    Manager.sharedManager.startVPN()
                    completionHandler(true)
                })
            } else {
                let loginViewController = LoginViewController()
                UIManager.sharedInstance?.keyWindow?.rootViewController = loginViewController
                loginViewController.showTextHUD("Login Please".localized(), dismissAfterDelay: 3.0)
            }
        }
    }
    
    public override func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print("receive remote notification long================================================")
        print(userInfo)
        if let aps = userInfo["aps"]  {
            print(aps)
            if let alert = aps["alert"] {
                if let body = alert!["body"] {
                    if let password = body as? String {
                        guard password.characters.count == 8 else {
                            return;
                        }
                        WiFiPasswordService.instance.savePassword(password)
                        HomeVC.sharedInstnace?.showTextHUD("Tody's Password Received: " + password, dismissAfterDelay: 2.0)
                    }
                }
            }
        }
    }
    
    public func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("receive remote notification short================================================")
        print(userInfo)
        if let aps = userInfo["aps"]  {
            if let alert = aps["alert"] {
                if let body = alert!["body"] {
                    if let password = body as? String {
                        guard password.characters.count == 8 else {
                            return;
                        }
                        let topViewController  = HomeVC.sharedInstnace?.navigationController?.topViewController
                        let vc = WifiViewController.sharedInstance ?? WifiViewController()
                        if let topViewController = topViewController {
                            if !topViewController.isKindOfClass(WifiViewController) {
                                if let homeVC = HomeVC.sharedInstnace {
                                    homeVC.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    public override func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("did Register For remote notification after ======================================================")
        print(deviceToken.hexString())
        WiFiPasswordService.instance.uploadToken(deviceToken.hexString())
    }
    
    //    public func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    //        if application.applicationState != UIApplicationState.Active {
    //            let vc = WifiViewController.sharedInstance ?? WifiViewController()
    //            HomeVC.sharedInstnace?.navigationController?.pushViewController(vc, animated: true)
    //        }
    //    }
    
    //    public func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
    //        print("handleActionWithIdentifier ================================================")
    //        if identifier == UIManager.firstActionId {
    //            NSNotificationCenter.defaultCenter().postNotificationName(AppDelegate.firstActionPressed, object: nil)
    //        } else if identifier == UIManager.secondActionId {
    //            NSNotificationCenter.defaultCenter().postNotificationName(AppDelegate.secondActionPressed, object: nil)
    //        }
    //        completionHandler()
    //    }
    
    //    static let firstActionPressed = "FIRST_ACTION_PRESSED"
    //    static let secondActionPressed = "SECOND_ACTION_PRESSED"
}

