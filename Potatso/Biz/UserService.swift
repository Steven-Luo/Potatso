//
//  UserService.swift
//  Potatso
//
//  Created by luogang on 16/10/13.
//  Copyright © 2016年 Abest Proxy. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class UserService: NSObject {
    static let sharedInstance = UserService()
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    private static let kUsername = "username"
    private static let kPassword = "kPassword"
    private static let kToken = "token"
    private static let kUserId = "userId"
    private static let kExpireDate = "expireDate"
    private static let kTrafficTotal = "traffic.total"
    private static let kTrafficDownload = "traffic.download"
    private static let kTrafficUpload = "traffic.upload"
    
    func saveToken(tokenValue: String, userId: Int) {
        let today = NSDate()
        let expireDate = today.dateByAddingTimeInterval(7*24*60*60)
        self.userDefaults.setValue(tokenValue, forKey: UserService.kToken)
        self.userDefaults.setValue(userId, forKey: UserService.kUserId)
        self.userDefaults.setValue(expireDate, forKey: UserService.kExpireDate)
        self.userDefaults.synchronize()
    }
    
    func save(username username: String, password: String) {
        self.userDefaults.setValue(username, forKey: UserService.kUsername)
        self.userDefaults.setValue(password, forKey: UserService.kPassword)
        self.userDefaults.synchronize()
    }
    
    func getUsernamePasswd() -> (username: String?, password: String?) {
        let username = self.userDefaults.stringForKey(UserService.kUsername)
        let password = self.userDefaults.stringForKey(UserService.kPassword)
        return (username, password)
    }
    
    func getToken() -> (value: String?, expireDate: NSDate?, userId: Int?) {
        let token = self.userDefaults.stringForKey(UserService.kToken)
        let expireDate = self.userDefaults.objectForKey(UserService.kExpireDate) as? NSDate
        let userId = self.userDefaults.integerForKey(UserService.kUserId)
        return (value: token, expireDate: expireDate, userId: userId)
    }
    
    func refreshToken() {
        let user = getUsernamePasswd()
        guard let username = user.username, password = user.password else{
            return
        }
        Alamofire.request(.POST, AbestProxyAPI.sharedInstance.ACCESS_TOKEN_API,
            parameters: ["email":username, "passwd":password, "remember_me":"week"],
            encoding: ParameterEncoding.URLEncodedInURL,
            headers: nil).responseJSON { response in
                if response.result.isSuccess {
                    let result =  JSON(response.result.value!)
                    print("access token: \(result)")
                    
                    guard let resultCode = result["ret"].int
                        where resultCode == 1 else {
                            return
                    }
                    let token = result["data"]["token"].stringValue
                    let userId = result["data"]["user_id"].intValue
                    self.saveToken(token, userId: userId)
                }
        }
    }
    
    func removeToken() {
        self.userDefaults.removeObjectForKey(UserService.kToken)
        self.userDefaults.removeObjectForKey(UserService.kExpireDate)
    }
    
    func fetchTrafficUsage(completion : (() -> ())? = nil) {
        let (token , _ , userId) = getToken()
        if  let token = token, userId = userId{
            Alamofire.request(.GET, AbestProxyAPI.sharedInstance.USER_API + "\(userId)", parameters: nil,
                encoding: ParameterEncoding.URLEncodedInURL, headers: ["Token": token]).responseJSON { (response) in
                    if response.result.isSuccess {
                        let result = JSON(response.result.value!)
                        guard let returnCode = result["ret"].int where returnCode == 1 else {
                            return
                        }
                        if let data = result["data"].dictionaryObject {
                            let total = (Float)(data["transfer_enable"] as! Int) / (Float)(1024*1024*1024)
                            let upload = (Float)(data["u"] as! Int) / (Float)(1024*1024*1024)
                            let download = (Float)(data["d"] as! Int) / (Float)(1024*1024*1024)
                            self.saveTrafficUsage(total, upload: upload, download: download)
                            
                            if let completion = completion {
                                completion()
                            }
                        }
                    }
            }
        }
    }
    
    func saveTrafficUsage(total: Float, upload: Float, download: Float) {
        self.userDefaults.setValue(total, forKey: UserService.kTrafficTotal)
        self.userDefaults.setValue(upload, forKey: UserService.kTrafficUpload)
        self.userDefaults.setValue(download, forKey: UserService.kTrafficDownload)
        self.userDefaults.synchronize()
    }
    
    func getTrafficUsage() -> (total: Float, upload: Float, download: Float, available: Float) {
        let total = self.userDefaults.floatForKey(UserService.kTrafficTotal)
        let upload = self.userDefaults.floatForKey(UserService.kTrafficUpload)
        let download = self.userDefaults.floatForKey(UserService.kTrafficDownload)
        
        let available = total - upload - download
        
        return (total: total, upload: upload, download: download, available: available)
    }
}
