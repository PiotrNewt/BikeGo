//
//  RideRecord.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/11.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import Foundation
import RealmSwift

class RideRecord: Object {
    
    @objc dynamic var userID: Int = 0
    @objc dynamic var locations: [CLLocation] = []
    @objc dynamic var times: [Data] = []
    
}
