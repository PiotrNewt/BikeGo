//
//  DashBoardViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/3/30.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import CoreMotion
import RealmSwift
import Alamofire
import SwiftyJSON

//用于数据点采样的方法判断
enum compressionTyPe {
    case combine
    case sample
}

class DashBoardViewController: UIViewController {

    var timer = Timer()
    var mtimer = Timer()
    var mtimes = 0
    
    //时间
    var min = 0
    var sec = 0
    
    let locationManager = AMapLocationManager()
    let motionManager = CMMotionManager()
    //用于一次记录点
    var recordPois: [RecordPoint] = [RecordPoint]()
    // 用于不同方法下调用
    var ifDashVCAppear = true
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedView: SpeedView!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var RideBtn: UIButton!
    @IBOutlet weak var EndRideBtn: UIButton!
    @IBOutlet weak var RideInfoView: UIView!
   
    @IBOutlet weak var PageC: UIPageControl!
    
    var altitudeLabel = UILabel()
    var timeLabel = UILabel()
    var balanceLabel = UILabel()
    
    var centerFrame: CGRect!
    var leftFrame: CGRect!
    var rightFrame: CGRect!
    
    @IBOutlet weak var BottomLabel: UILabel!
    
    @IBAction func BackBtnClick(_ sender: Any) {
        //to-do 关闭处理（）
        self.hero.dismissViewController()
    }
    
    
    @IBAction func RideBtnClick(_ sender: Any) {
        startRecordRideData()
        testLabel.text = "定位真的开启了喽"
    }
    
    @IBAction func EndRideBtnClick(_ sender: Any) {
        endRecordRideData()
        getSystemLocationInfo(speed: 0.0)
        altitudeLabel.text = "0.0∆"
        timeLabel.text = "00:00"
        min = 0
        sec = 0
        balanceLabel.text = "0.0˚"
        testLabel.text = "定位怕是结束了哦"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        
        setRideInfoView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mtimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(openAnimation), userInfo: nil, repeats: true)
    }
    
    //启动动画
    @objc func openAnimation() {
        mtimes += 1
        switch mtimes {
        case 5,30:
            rideInfoViewSwipToRight()
            break
        case 18:
            rideInfoViewSwipToLeft()
            rideInfoViewSwipToLeft()
            break
        case 40:
            getSystemLocationInfo(speed: Double(0.6))
            getSystemLocationInfo(speed: Double(0))
            mtimer.invalidate()
            EndRideBtn.isEnabled = false
            return
        default:
            break
        }
        if mtimes < 31{
            getSystemLocationInfo(speed: Double(mtimes))
        }
    }
    
    func setRideInfoView(){
        
        self.view.addSubview(RideInfoView)
        
        centerFrame = CGRect(x: UIScreen.main.bounds.width / 2 - 50, y: RideInfoView.frame.height / 2 - 18, width: 100, height: 35)
        leftFrame = CGRect(x: UIScreen.main.bounds.width / 2 - 50 - 100, y: RideInfoView.frame.height / 2 - 18, width: 100, height: 35)
        rightFrame = CGRect(x: UIScreen.main.bounds.width / 2 - 50 + 100, y: RideInfoView.frame.height / 2 - 18, width: 100, height: 35)

        timeLabel.text = "00:00"
        timeLabel.textColor = UIColor.white
        timeLabel.font = UIFont.init(name: "Arial Rounded MT Bold", size: 30)
        timeLabel.textAlignment = .center
        timeLabel.frame = centerFrame
        RideInfoView.addSubview(timeLabel)
        
        altitudeLabel.text = "0.0∆"
        altitudeLabel.textColor = UIColor.white
        altitudeLabel.font = UIFont.init(name: "Arial Rounded MT Bold", size: 15)
        altitudeLabel.textAlignment = .center
        altitudeLabel.frame = leftFrame
        RideInfoView.addSubview(altitudeLabel)
        
        balanceLabel.text = "0.0˚"
        balanceLabel.textColor = UIColor.white
        balanceLabel.font = UIFont.init(name: "Arial Rounded MT Bold", size: 15)
        balanceLabel.textAlignment = .center
        balanceLabel.frame = rightFrame
        RideInfoView.addSubview(balanceLabel)
        
        timeLabel.alpha = 1
        altitudeLabel.alpha = 0
        balanceLabel.alpha = 0
        
        PageC.currentPage = 1
        BottomLabel.text = "时间"
        
        //添加滑动手势
        let swipLeft = UISwipeGestureRecognizer(target: self, action: #selector(rideInfoViewSwipToLeft))
        let swipRight = UISwipeGestureRecognizer(target: self, action: #selector(rideInfoViewSwipToRight))
        swipLeft.direction = UISwipeGestureRecognizerDirection.left
        swipRight.direction = UISwipeGestureRecognizerDirection.right
        self.RideInfoView.addGestureRecognizer(swipLeft)
        self.RideInfoView.addGestureRecognizer(swipRight)
        
    }
    
    //侧滑手势
    @objc func rideInfoViewSwipToLeft() {
        switch PageC.currentPage {
        case 0:
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {() -> Void in
                self.PageC.currentPage = 1
                self.timeLabel.font = UIFont.init(name: "Arial Rounded MT Bold", size: 30)
                self.altitudeLabel.font = UIFont.init(name: "Arial Rounded MT Bold", size: 15)
                self.timeLabel.frame = self.centerFrame
                self.altitudeLabel.frame = self.leftFrame
                self.timeLabel.alpha = 1
                self.altitudeLabel.alpha = 0
                self.balanceLabel.alpha = 0
                self.BottomLabel.text = "时间"
            }, completion: nil)
            break
        case 1:
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {() -> Void in
                self.PageC.currentPage = 2
                self.timeLabel.font = UIFont.init(name: "Arial Rounded MT Bold", size: 15)
                self.balanceLabel.font = UIFont.init(name: "Arial Rounded MT Bold", size: 30)
                self.timeLabel.frame = self.leftFrame
                self.balanceLabel.frame = self.centerFrame
                self.timeLabel.alpha = 0
                self.altitudeLabel.alpha = 0
                self.balanceLabel.alpha = 1
                self.BottomLabel.text = "平衡"
            }, completion: nil)
        case 2:
            break
        default:
            return
        }
    }
    @objc func rideInfoViewSwipToRight() {
        switch PageC.currentPage {
        case 0:
            break
        case 1:
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {() -> Void in
                self.PageC.currentPage = 0
                self.timeLabel.font = UIFont.init(name: "Arial Rounded MT Bold", size: 15)
                self.altitudeLabel.font = UIFont.init(name: "Arial Rounded MT Bold", size: 30)
                self.timeLabel.frame = self.rightFrame
                self.altitudeLabel.frame = self.centerFrame
                self.timeLabel.alpha = 0
                self.altitudeLabel.alpha = 1
                self.balanceLabel.alpha = 0
                self.BottomLabel.text = "海拔"
            }, completion: nil)
        case 2:
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {() -> Void in
                self.PageC.currentPage = 1
                self.timeLabel.font = UIFont.init(name: "Arial Rounded MT Bold", size: 30)
                self.balanceLabel.font = UIFont.init(name: "Arial Rounded MT Bold", size: 15)
                self.timeLabel.frame = self.centerFrame
                self.balanceLabel.frame = self.rightFrame
                self.timeLabel.alpha = 1
                self.altitudeLabel.alpha = 0
                self.balanceLabel.alpha = 0
                self.BottomLabel.text = "时间"
            }, completion: nil)
        default:
            return
        }
    }
    
    func getSystemLocationInfo(speed: Double) -> Void {
        //let speed = Int(arc4random_uniform(50))+1
        //NSLog("当前速度：\(speed)")
        let nowspeed: Int = speed <= 0.5 ? 0 : Int(speed)
        //更新主屏显示
        speedView.speedValue = CGFloat(nowspeed)
        speedLabel.text = String(Int(nowspeed))
    }
    
    //骑行开始
    func startRecordRideData() {
        
        RideBtn.isEnabled = false
        EndRideBtn.isEnabled = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.locationTimeout = 10
        locationManager.reGeocodeTimeout = 10
        NSLog("骑行开始")
        locationManager.startUpdatingLocation()
        
        //开启加速计
        startRecodeDeviceMotion()
        
        //用个什么来记录一下骑行信息（RidedataModel） -> 在持续定位的回调中写入信息 Done
        //调出设备的加速计算法func 监听设备情况 —> 是否摔倒、显示倾角Because in my memory, Thai restaurants are high-end restaurants.
    }
    
    //骑行结束
    func endRecordRideData() {
        
        RideBtn.isEnabled = true
        EndRideBtn.isEnabled = false
        
        //停止监听设备移动
        motionManager.stopDeviceMotionUpdates()
        timer.invalidate()
        
        NSLog("骑行结束")
        locationManager.stopUpdatingLocation()
        //结束啦喽，将骑行信息存入用户数据库
        //判断一下点是不是不够哎
        guard recordPois.count >= 100 else {
            
            NSLog("这波行程太短")
            let tip = TipBubble()
            tip.BubbackgroundColor = UIColor.colorFromHex(hexString: "#FFFFFF").withAlphaComponent(0.6)
            tip.TipTextColor = UIColor.black
            tip.TipContent = "行程太短"
            self.view.addSubview(tip)
            tip.show(dalay: 2)
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
        if speed < 0.5 {
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
    
    //开始获取设备移动信息
    func startRecodeDeviceMotion(){
        if motionManager.isAccelerometerAvailable,
            motionManager.isGyroAvailable{
            self.motionManager.deviceMotionUpdateInterval = 1 / 60
            let queue = OperationQueue.current
            self.motionManager.startDeviceMotionUpdates(to: queue!, withHandler:{
                (MotionData,error)  in
                NSLog(String(format: "%.1f", (MotionData?.userAcceleration.x)!))
            })
           // self.motionManager.startDeviceMotionUpdates()
        }else{
            //to do 警告设备加速计不能使用
            NSLog("设备加速计或者陀螺仪不能使用")
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(judgeDeviceMotion), userInfo: nil, repeats: true)
    }
    
    //判断是否出事故
    @objc func judgeDeviceMotion(){
//        if let newMotionData = self.motionManager.deviceMotion{
//            NSLog("姿态旋转\(newMotionData.attitude.roll)")
//            NSLog("姿态偏移\(newMotionData.attitude.yaw)")
//            NSLog("陀螺仪旋转y\(newMotionData.rotationRate.x)")
//            NSLog("加速度x\(newMotionData.userAcceleration.x)")
//        }
        
        //时间函数
        sec += 1
        if sec >= 60{
            min += 1
        }
        var sst = String(sec)
        var mst = String(min)
        if sec < 10 {
            sst = "0" + sst
        }
        if sec < 10 {
            mst = "0" + mst
        }
        timeLabel.text = mst + ":" + sst
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

extension DashBoardViewController: AMapLocationManagerDelegate, UIAccelerometerDelegate{
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
        NSLog("位置刷新")
        if ifDashVCAppear == true{
            getSystemLocationInfo(speed: location.speed * 3.6)
            testLabel.text = String(location.speed)
            altitudeLabel.text = String(format: "%.1f", location.altitude) + "∆"
        }
        //内存中写入数据
        writeRideDate(location: location)
    }
}

