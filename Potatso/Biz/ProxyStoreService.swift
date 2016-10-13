//
//  ProxyStoreService.swift
//  Potatso
//
//  Created by luogang on 16/10/11.
//  Copyright © 2016年 TouchingApp. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProxyStoreService: NSObject {
    static private let existingProxies = ProxyStoreService.listProxies()
    
    class func listProxies() -> [Proxy] {
        let proxies = DBUtils.allNotDeleted(Proxy.self, sorted: "createAt").map({ $0 })
        return proxies
    }

    class func addProxy(proxy: Proxy) {
        do {
            try DBUtils.add(proxy)
        }catch {
            print("Error")
        }
    }
    
    class func isProxyExists(name: String) -> Bool {
        for proxy in existingProxies {
            if proxy.name == name {
                return true
            }
        }
        return false
    }

    class func addProxies(proxies: [JSON]) {
        
        for proxyJSON in proxies {
            let name = proxyJSON["server"].stringValue
            if isProxyExists(name) {
                continue
            }
            
            let proxy = Proxy()
            proxy.type = ProxyType.Shadowsocks
            proxy.name = name
            proxy.host = proxyJSON["server"].stringValue
            proxy.port = proxyJSON["server_port"].intValue
            proxy.authscheme = proxyJSON["method"].stringValue
            proxy.password = proxyJSON["password"].stringValue
            
            addProxy(proxy)
        }
    }
}
