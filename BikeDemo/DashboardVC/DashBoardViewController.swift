//
//  DashBoardViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/3/30.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

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
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.locationTimeout = 10
        locationManager.reGeocodeTimeout = 10
    
        //timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(getSystemLocationInfo), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    @objc func getSystemLocationInfo(speed: Double) -> Void {
        //let speed = Int(arc4random_uniform(50))+1
        NSLog("当前速度：\(speed)")
        let nowspeed: Int = speed <= 1 ? 0 : Int(speed)
        //更新主屏显示
        speedView.speedValue = CGFloat(nowspeed)
        speedLabel.text = String(Int(nowspeed))
    }
    
    //骑行开始
    func startRecordRideData() {
        locationManager.startUpdatingLocation()
        //用个什么来记录一下骑行信息（RidedataModel） -> 在持续定位的回调中写入信息
        //调出设备的加速计算法func 监听设备情况 —> 是否摔倒、显示倾角
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
        
        //清空用于记录的数组
        recordPois.removeAll()
        
    }
    
    //每次改变位置后向内存写入位置信息
    func writeRideDate(location: CLLocation){
        let locationPoi = RecordPoint()
        locationPoi.altitude = location.altitude
        locationPoi.latitude = location.coordinate.latitude
        locationPoi.longitude = location.coordinate.longitude
        locationPoi.speed = location.speed * 3.6 // m/s -> km/h
        locationPoi.times = Date()
        
        self.recordPois.append(locationPoi)
    }
    
    /*
     *  全局发送短信
     *  独立定位管理：不会被持续定位打断
     *  to-do 只有在获取到足够信息之后才发送短信 -> 多次定位
     */
    static func sendMessageWithDeviceLocation(phone: String, name: String) {
        
        let SmslocationManager = AMapLocationManager()
        SmslocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        SmslocationManager.locatingWithReGeocode = true
        SmslocationManager.reGeocodeTimeout = 10
        SmslocationManager.locationTimeout = 10
        
        let mm = SmslocationManager.requestLocation(withReGeocode: true, completionBlock: { (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            
            let queue = DispatchQueue(label: "BikeDemo.mclarenyang")
            queue.async {
                
            if let error = error {
                let error = error as NSError
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    return
                }else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue
                    || error.code == AMapLocationErrorCode.canceled.rawValue{
                    NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                    //to do 错误提示
                }else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作
                    var address = "位置信息获取失败，请电话联系\(name)"
                    
                    if let location = location {
                        address = "经纬度:\(location.coordinate.longitude),\(location.coordinate.latitude)"
                        if let reGeocode = reGeocode {
                            address = "\(reGeocode.aoiName)\n经纬度:\(location.coordinate.longitude),\(location.coordinate.latitude)"
                        }
                    }
                    
                    NSLog("\(address)")
                    
//                    let queue = DispatchQueue(label: "BikeDemo.mclarenyang")
//                    queue.sync {
//
//                    let parameters: Parameters = [
//                        "phone": phone,
//                        "name": name,
//                        "address": address
//                        ]
//                    //网络请求
//                    let url = MenuViewController.APIURLHead + "sms/send"
//                    Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
//                        request in
//                        if let value = request.result.value{
//                            let json = JSON(value)
//                            let code = json[]["code"]
//                            print(json)
//                            if code == 200{
//                                NSLog("发送成功")
//                            }else{
//                                // to do 失败提示
//                                NSLog("发送失败")
//                            }
//                        }
//                    }
//                }
                } }
            }
        })
        NSLog("mm:\(mm)")
    }
}

extension DashBoardViewController: AMapLocationManagerDelegate{
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {

        getSystemLocationInfo(speed: location.speed * 3.6)
        //向数据库中写入数据
        //writeRideDate(location: location)
        testLabel.text = String(location.speed)
    }
}

