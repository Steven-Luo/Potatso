//
//  WiFiPasswordService.swift
//  Potatso
//
//  Created by luogang on 2017/2/21.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WiFiPasswordService {
    static let instance = WiFiPasswordService()
    
    static let WiFiFetchServer = "http://l.abest.me/pass_json.php"
    static let PushServerRegister = "http://thinkcreatively.top:8080/push_server/push_info/login"
    static let kNotify = "notify_daily"
    static let kPassword = "clear_guest_password"
    static var sharedInstance: WifiViewController?
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var token: String?

    func getWiFiPasswordAsync(completeHanler: JSON->()) {
        Alamofire.request(.POST, WiFiPasswordService.WiFiFetchServer,
            parameters: nil,
            encoding: ParameterEncoding.URLEncodedInURL,
            headers: nil).responseJSON {response in
                print("get wifi async: \(response)")
                if response.result.isSuccess {
                    let result =  JSON(response.result.value!)
                    completeHanler(result)
                }
        }
    }
    
    func savePassword(password: String) {
        userDefaults.setValue(password, forKey: WiFiPasswordService.kPassword)
    }
    
    func getPassword() -> String? {
        return userDefaults.valueForKey(WiFiPasswordService.kPassword) as? String
    }
    
    func uploadToken(tokenValue: String?, oracleUser: Bool = false) {
        self.token = tokenValue
        
        var token = "nil"
        if let t = tokenValue {
            token = t
        }
        let deviceName = UIDevice.currentDevice().name
        let modelName = UIDevice.currentDevice().modelName
        var deviceId = ""
        if let id = UIDevice.currentDevice().identifierForVendor?.UUIDString {
            deviceId = id
        }
        let systemVersion = UIDevice.currentDevice().systemVersion
        
        var param: [String: String] = ["token":token, "deviceName": deviceName, "deviceId": deviceId, "deviceModel": modelName, "systemVersion": systemVersion]
        if oracleUser {
            param["oracleUser"] = String(1)
        }
        
        Alamofire.request(.POST, WiFiPasswordService.PushServerRegister,
            parameters: param,
            encoding: ParameterEncoding.URLEncodedInURL,
            headers: nil).responseJSON {response in
                print("PushServerRegister: \(response)")
        }
    }

}
