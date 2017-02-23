//
//  WifiViewController.swift
//  Potatso
//
//  Created by luogang on 2016/12/15.
//  Copyright © 2016年 TouchingApp. All rights reserved.
//

import Foundation
import Eureka
import Alamofire
import SwiftyJSON

class WifiViewController: FormViewController {
    let wifiService = WiFiPasswordService.instance
    let userDefaults = NSUserDefaults.standardUserDefaults()
    static var sharedInstance: WifiViewController?
    static let kNotify = "notify_daily"

    var password: String?

//    func registerLocalNotification() {
//        let formatter = NSDateFormatter()
//        formatter.dateFormat="HH:mm:ss"
////        let now = formatter.dateFromString("22:23")
//        
////        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WifiViewController.actionOne), name: AppDelegate.firstActionPressed, object: nil)
////        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WifiViewController.actionTwo), name: AppDelegate.secondActionPressed, object: nil)
//        
//        let notification = UILocalNotification()
//        notification.fireDate = NSDate(timeIntervalSinceNow: 10)
//        notification.timeZone = NSTimeZone()
//        notification.repeatInterval = NSCalendarUnit.Minute
//        notification.soundName = UILocalNotificationDefaultSoundName
//        notification.alertBody = "今日wifi密码已生成，点击获取"
//        notification.userInfo = ["name": "wifi"]
//        
//        notification.category = UIManager.firstCategoryId
//        
//        UIApplication.sharedApplication().scheduleLocalNotification(notification)
//    }
    
//    func actionOne(notification: NSNotification) {
//        self.showTextHUD("First Action", dismissAfterDelay: 2.0)
//    }
//    
//    func actionTwo(notification: NSNotification) {
//        self.showTextHUD("Second Action", dismissAfterDelay: 2.0)
//        
//        let message: UIAlertController = UIAlertController(title: "A notification message", message: "hello world", preferredStyle: UIAlertControllerStyle.Alert)
//        message.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//        
//        self.presentViewController(message, animated: true, completion: nil)
//    }
    
//    func cancelLocalNotification() {
//        let localNotifications = UIApplication.sharedApplication().scheduledLocalNotifications
//        for nf in localNotifications! {
//            UIApplication.sharedApplication().cancelLocalNotification(nf)
////            if nf.userInfo?["name"]?.stringValue == "wifi" {
////                UIApplication.sharedApplication().cancelLocalNotification(nf)
////            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WifiViewController.sharedInstance = self
    }
    
    override func viewWillAppear(animated: Bool) {
        generateForm()
        
        let notifySetting = userDefaults.stringForKey(WifiViewController.kNotify)
        if notifySetting == "on" {
            let switchRow = self.form.rowByTag("switchRow") as! SwitchRow
            switchRow.value = true
            switchRow.updateCell()
        }
        
        navigationItem.title = "Today's WiFi Password".localized()
        
        let pass = wifiService.getPassword()
        if let pass = pass {
            guard !pass.isEmpty else {
                refreshPassword()
                return
            }
            let passwordRow = self.form.rowByTag("passswordRow") as! LabelRow
            passwordRow.value = pass
            self.password = pass
        } else {
            refreshPassword()
        }
    }
    
    func generateForm() {
        form.delegate = nil
        form.removeAll()
        form+++generateSection()
        form.delegate = self
        tableView?.reloadData()
    }
    
    func refreshPassword() {
        let passwordRow = self.form.rowByTag("passswordRow") as! LabelRow
        passwordRow.disabled = true
        
        wifiService.getWiFiPasswordAsync() { [unowned self] result in
            let pass = result["data"].stringValue
            self.password = pass
            self.wifiService.savePassword(pass)
            
            passwordRow.value = pass
            passwordRow.updateCell()
        }
    }
    
    func generateSection() -> Section {
        let section = Section()
        section<<<SwitchRow {
            $0.title = "Notify Daily".localized()
            $0.tag = "switchRow"
            }.onChange { [unowned self] row in
                if(row.value!) {
                    self.userDefaults.setValue("on", forKey: WifiViewController.kNotify)
                    self.wifiService.uploadToken(WiFiPasswordService.instance.token, oracleUser: true)
                } else {
                    self.userDefaults.setValue("off", forKey: WifiViewController.kNotify)
                    self.wifiService.uploadToken(WiFiPasswordService.instance.token, oracleUser: false)
                }
        }
        section<<<LabelRow {
            $0.title = "JAPAC Password".localized()
            $0.value = "Fetching".localized()
            $0.tag = "passswordRow"
        }
        section<<<ButtonRow {
            $0.title = "Refresh Password".localized()
            $0.tag = "refreshButtonRow"
            }.onCellSelection({[unowned self](cell, row) in
                let passwordRow = self.form.rowByTag("passswordRow") as! LabelRow
                passwordRow.value = "Fetching".localized()
                passwordRow.updateCell()
                self.refreshPassword()
            })
        section<<<ButtonRow {
            $0.title = "Copy Password".localized()
            $0.tag = "copyButtonRow"
            }.onCellSelection({[unowned self](cell, row) in
                self.copyPassword(self.password!)
                })
        return section
    }
    
    func copyPassword(password: String) {
        UIPasteboard.generalPasteboard().string = password
        self.showTextHUD("Password Copied".localized(), dismissAfterDelay: 2.0)
    }
}