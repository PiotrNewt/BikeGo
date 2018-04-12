//
//  DashBoardViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/3/30.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import RealmSwift

class DashBoardViewController: UIViewController {
    
    var timer = Timer()
    let locationManager = AMapLocationManager()
    //用于一次记录点
    var recordPois: [RecordPoint] = [RecordPoint]()
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedView: SpeedView!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var RideBtn: UIButton!
    
    
    @IBAction func RideBtnClick(_ sender: Any) {
        startRecordRideData()
        RideBtn.titleLabel?.text = "sss"
        testLabel.text = "定位真的开启了喽"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.locationTimeout = 10
    
        //timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(getSystemLocationInfo), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    @objc func getSystemLocationInfo(speed: Double) -> Void {
        //let speed = Int(arc4random_uniform(50))+1
        NSLog("当前速度：\(speed)")
        let nowspeed = speed == -1 ? 0 : speed
        guard speed != 0 else {
            return
        }
        speedView.speedValue = CGFloat(nowspeed)
        speedLabel.text = String(Int(nowspeed))
    }
    
    //骑行开始
    func startRecordRideData() {
        locationManager.startUpdatingLocation()
        //用个什么来记录一下骑行信息（RidedataModel） -> 在持续定位的回调中写入信息
        //调出设备的加速计算法func
    }
    
    //骑行结束
    func endRecordRideData() {
        locationManager.stopUpdatingLocation()
        //结束啦喽，将骑行信息存入用户数据库
        let defaults = UserDefaults.standard
        let userID = String(describing: defaults.value(forKey: "UserID")!)
        
        let rideRecord = RideRecord()
        rideRecord.userID = Int(userID)!
        
        for poi in recordPois {
            poi.subOne = rideRecord
            rideRecord.recordPoints.append(poi)
        }
        let realm = try! Realm()
        try! realm.write {
            realm.add(rideRecord)
        }
        
    }
    
    //全局短信接口
    static func sendMessageWithDeviceLocation() {
        let locationManager = AMapLocationManager()
        locationManager.requestLocation(withReGeocode: false, completionBlock: { (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            
            if let error = error {
                let error = error as NSError
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                }
                else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，发送短信
                    
                }
            }
            
            if let location = location {
                NSLog("location:%@", location)
            }
            
            if let reGeocode = reGeocode {
                NSLog("reGeocode:%@", reGeocode)
                NSLog("reGeocodeName:%@", reGeocode.aoiName)
            }
        })
    }
}

extension DashBoardViewController: AMapLocationManagerDelegate {
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
        NSLog("speed：\(location.speed)")
        getSystemLocationInfo(speed: location.speed / 3.6)
        //向数据库中写入数据 func(location)
        testLabel.text = String(location.speed)
    }
}

