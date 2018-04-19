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

//用于数据点采样的方法判断
enum compressionTyPe {
    case combine
    case sample
}

class DashBoardViewController: UIViewController {

    let locationManager = AMapLocationManager()
    //用于一次记录点
    var recordPois: [RecordPoint] = [RecordPoint]()
    // 用于不同方法下调用
    var ifDashVCAppear = true
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedView: SpeedView!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var RideBtn: UIButton!
    
    
    @IBAction func RideBtnClick(_ sender: Any) {
        startRecordRideData()
        RideBtn.titleLabel?.text = "sss"
        testLabel.text = "定位真的开启了喽"
    }
    
    @IBAction func EndRideBtnClick(_ sender: Any) {
        endRecordRideData()
        testLabel.text = "定位怕是结束了哦"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.locationTimeout = 10
        locationManager.reGeocodeTimeout = 10
        NSLog("骑行开始")
        locationManager.startUpdatingLocation()
        //用个什么来记录一下骑行信息（RidedataModel） -> 在持续定位的回调中写入信息 Done
        //调出设备的加速计算法func 监听设备情况 —> 是否摔倒、显示倾角Because in my memory, Thai restaurants are high-end restaurants.
    }
    
    //骑行结束
    func endRecordRideData() {
        NSLog("骑行结束")
        locationManager.stopUpdatingLocation()
        //结束啦喽，将骑行信息存入用户数据库
        //判断一下点是不是不够哎
        guard recordPois.count >= 10 else {
            //to do  弹行程太短警告
            NSLog("这波行程太短")
            return
        }
        
        //开个队列处理一下
        let queue = DispatchQueue(label: "BikeDemo.mclarenyang", attributes: .concurrent)
        queue.async {
            let defaults = UserDefaults.standard
            let userID = String(describing: defaults.value(forKey: "UserID")!)
        
            //采样处理
            self.recordPois = self.samplingRideData(pois: self.recordPois)
            
            let rideRecord = RideRecord()
            rideRecord.userID = Int(userID)!
        
            for poi in self.recordPois {
                poi.subOne = rideRecord
                rideRecord.recordPoints.append(poi)
            }
            let realm = try! Realm()
            try! realm.write {
                realm.add(rideRecord)
                NSLog("骑行数据已经存入数据库")
            }
        
            //清空用于记录的数组
            self.recordPois.removeAll()
        }
    }
    
    //每次改变位置后向内存写入位置信息
    func writeRideDate(location: CLLocation){
        let locationPoi = RecordPoint()
        locationPoi.altitude = location.altitude
        locationPoi.latitude = location.coordinate.latitude
        locationPoi.longitude = location.coordinate.longitude
        let speed = location.speed * 3.6 // m/s -> km/h
        if speed < 1 {
            locationPoi.speed = 0
        }else{
            locationPoi.speed = speed
        }
        locationPoi.times = Date()
        
        self.recordPois.append(locationPoi)
    }
    
    //数据点采样处理 - 根据数据点选择方法及采样率
    func samplingRideData(pois: [RecordPoint]) -> [RecordPoint] {
        switch pois.count {
        case 10...50:
            return pois
        case 51...250:
            return comPoi(pois: pois, ratio: 5, compressionTyPe: .combine)
        case 251...1250:
            return comPoi(pois: pois, ratio: 25, compressionTyPe: .combine)
        case 1251...6250:
            return comPoi(pois: pois, ratio: 125, compressionTyPe: .combine)
        case 6251...31250:
            return comPoi(pois: pois, ratio: 625, compressionTyPe: .combine)
        case 31251...312500:
            return comPoi(pois: pois, ratio: 700, compressionTyPe: .sample)
        default:
            return pois
        }
    }
    
    //点合成方法 - 合成、采样
    func comPoi(pois: [RecordPoint], ratio: Int ,compressionTyPe: compressionTyPe) -> [RecordPoint]{
        var nowPois: [RecordPoint] = [RecordPoint]()
        var speed = 0.0
        var altitude = 0.0
        var index = 1
        if compressionTyPe == .combine {
            for poi in pois{
                speed += poi.speed
                altitude += poi.altitude
                index += 1
                if index == ratio || poi == pois[pois.endIndex - 1]{
                    poi.speed = speed / Double(index)
                    poi.altitude = altitude / Double(index)
                    nowPois.append(poi)
                    
                    speed = 0.0
                    altitude = 0.0
                    index = 1
                }
            }
            return nowPois
        }
        if compressionTyPe == .sample{
            for poi in pois{
                index += 1
                if index == ratio || poi == pois[pois.endIndex - 1]{
                    nowPois.append(poi)
                    index = 0
                }
            }
            return nowPois
        }
        return nowPois
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
        NSLog("位置刷新")
        if ifDashVCAppear == true{
            getSystemLocationInfo(speed: location.speed * 3.6)
            testLabel.text = String(location.speed)
        }
        //内存中写入数据
        writeRideDate(location: location)
    }
}

