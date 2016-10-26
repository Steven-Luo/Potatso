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
//import IQKeyboardManagerSwift

class UIManager: NSObject, AppLifeCycleProtocol {
    static var sharedInstance: UIManager?
    
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
        return true
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
