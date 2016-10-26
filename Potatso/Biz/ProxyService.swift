//
//  ProxyStoreService.swift
//  Potatso
//
//  Created by luogang on 16/10/11.
//  Copyright © 2016年 TouchingApp. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ProxyService: NSObject {
    static let sharedInstance = ProxyService()
    
    private var proxies: [Proxy]? {
        get {
            if ( self.proxies == nil) {
                self.proxies = listProxies()
            }
            return self.proxies
        } set {
            self.proxies = newValue
        }
    }
    
    func listProxies() -> [Proxy] {
        let proxies = DBUtils.allNotDeleted(Proxy.self, sorted: "createAt").map({ $0 })
        return proxies
    }
    
    func addProxy(proxy: Proxy) {
        do {
            try DBUtils.add(proxy)
        }catch {
            print("Error")
        }
    }
    
    func isAbestProxyExists(param: Proxy) -> Bool {
        let proxies = listProxies()
        for proxy in proxies {
            if proxy.host == param.host && proxy.port == param.port && proxy.type == param.type
                && proxy.password == param.password && proxy.isAbest {
                return true
            }
        }
        return false
    }
    
    func addAbestProxies(proxies: [JSON]) {
        proxies.forEach { (proxyJSON) in
            let name = proxyJSON["server"].stringValue
            let proxy = Proxy()
            proxy.host = proxyJSON["server"].stringValue
            proxy.port = proxyJSON["server_port"].intValue
            proxy.password = proxyJSON["password"].stringValue
            
            if !isAbestProxyExists(proxy) {
                proxy.type = ProxyType.Shadowsocks
                proxy.name = name
                proxy.authscheme = proxyJSON["method"].stringValue
                proxy.isAbest = true
                
                addProxy(proxy)
            }
        }
    }
}
