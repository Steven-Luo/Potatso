//
//  User.swift
//  Potatso
//
//  Created by luogang on 16/10/13.
//  Copyright © 2016年 TouchingApp. All rights reserved.
//

import UIKit

struct Token {
    var value: String
    var createdTime: NSDate
    // day
    var lifetime: Int = 7
    
    init(value: String, createdTime: NSDate) {
        self.value = value
        self.createdTime = createdTime
    }
}


class AbestUser: Equatable {
    var id: Int
    var token: Token
    var totalTraffic: Int
    var uploadTraffic: Int
    var downloadTraffic: Int
    var usedTraffic: Int{
        get {
            return uploadTraffic + downloadTraffic
        }
    }
    var remainderTraffic: Int {
        get {
            return totalTraffic - usedTraffic
        }
    }
    var email: String
    
    init(id: Int, email: String, token: Token, totalTraffic: Int, uploadTraffic: Int, downloadTraffic: Int) {
        self.id = id
        self.email = email
        self.token = token
        self.totalTraffic = totalTraffic
        self.uploadTraffic = uploadTraffic
        self.downloadTraffic = downloadTraffic
    }
}

func == (lhs: Token, rhs: Token) -> Bool {
    return lhs.value == rhs.value
}

func == (lhs: AbestUser, rhs: AbestUser) -> Bool {
    return lhs.id == rhs.id && lhs.email == rhs.email && lhs.token == rhs.token
}
