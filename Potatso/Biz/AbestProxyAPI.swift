//
//  API.swift
//  Potatso
//
//  Created by luogang on 16/10/13.
//  Copyright © 2016年 TouchingApp. All rights reserved.
//

import UIKit

enum APIAccessResult: Int {
    case Success
    case UsernameOrPasswordWrong
    case NetworkUnreachable
    case ServerInternalError
    case AccessDenied
    
    var description: String {
        switch self {
        case .Success:
            return "Login Succeed".localized()
        case .UsernameOrPasswordWrong:
            return "Usernane or Password Wrong".localized()
        case .NetworkUnreachable:
            return "Network Unreachable".localized()
        case .ServerInternalError:
            return "Server Internal Error".localized()
        case .AccessDenied:
            return "Access Denied".localized()
        }
    }
}

struct AbestProxyAPI {
    static let sharedInstance = Product()
    
    struct Development {
        let ACCESS_TOKEN_API = "http://dev.abest.me/api/token"
        let PROXY_LIST_API = "http://dev.abest.me/api/ss/"
        let USER_API = "http://dev.abest.me/api/user/"
    }
    
    struct Product {
        let ACCESS_TOKEN_API = "http://dev.abest.me/api/token"
        let PROXY_LIST_API = "http://dev.abest.me/api/ss/"
        let USER_API = "http://dev.abest.me/api/user/"
    }
    
}
