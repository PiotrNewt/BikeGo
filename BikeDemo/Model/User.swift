//
//  User.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/4.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var userID: Int = 0
    @objc dynamic var userName: String = ""
    @objc dynamic var userPassword: String = ""
    @objc dynamic var userImg: NSData = NSData()
    @objc dynamic var userEmergencyPhone: String = ""
    @objc dynamic var userEmergencyMessage: String = "你好，我遇到了危险，请你尽快来帮助我!"
    
    //主键
    override static func primaryKey() -> String? {
        return "userID"
    }
}
