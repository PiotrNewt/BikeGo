//
//  RideRecord.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/11.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import Foundation
import RealmSwift

class RecordPoint: Object {
    
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var altitude: Double = 0.0
    @objc dynamic var speed: Double = 0.0
    @objc dynamic var times: Date? = nil
    @objc dynamic var subOne: RideRecord?
    
}

class RideRecord: Object {
    
    @objc dynamic var userID: Int = 0
    let recordPoints = List<RecordPoint>()
    
}
