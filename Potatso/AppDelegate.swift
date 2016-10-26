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
}

