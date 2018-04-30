//
//  DashBoardViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/3/30.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

//写触发事件 分别触发show 和 getdevice

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
    var countDownTimer = Timer()
    var mtimes = 0
    
    //时间
    var min = 0
    var sec = 0
    
    let locationManager = AMapLocationManager()
    let motionManager = CMMotionManager()
    let search = AMapSearchAPI()
    //用于一次记录点
    var recordPois: [RecordPoint] = [RecordPoint]()
    //极速模式
    var isHighSpeedMode = false
    //用于不同界面下调用
    var ifDashVCAppear = true
    //监控弹窗
    var alertController: UIAlertController!
    var alertAppear = false
    var countdown = 30
    
    //定位保障
    var address = ""
    var locationTimes = 0
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedView: SpeedView!

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
        
    }
    
    @IBAction func EndRideBtnClick(_ sender: Any) {
        endRecordRideData()
        getSystemLocationInfo(speed: 0.0)
        altitudeLabel.text = "0.0∆"
        timeLabel.text = "00:00"
        min = 0
        sec = 0
        balanceLabel.text = "0.0˚"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        search?.delegate = self
        
        if ifDashVCAppear == true{
            setRideInfoView()
            //添加切换极速模式的手势
            let moreTap = UITapGestureRecognizer.init(target:self, action: #selector(handleMoreTap(tap:)))
            moreTap.numberOfTapsRequired = 2
            self.speedView.addGestureRecognizer(moreTap)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mtimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(openAnimation), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        EndRideBtnClick(self)
    }
    
    //双击手势
    @objc func handleMoreTap(tap:UITapGestureRecognizer) {
        if isHighSpeedMode == false{
            UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveLinear, animations: {() -> Void in
                self.view.backgroundColor = UIColor.colorFromHex(hexString: "#F8B563")
            }, completion: nil)
            
            //警告进入极速模式
            let tip = TipBubble()
            tip.BubbackgroundColor = UIColor.colorFromHex(hexString: "#FFFFFF").withAlphaComponent(0.6)
            tip.TipTextColor = UIColor.black
            tip.TipContent = "极速模式"
            self.view.addSubview(tip)
            tip.show(dalay: 1.5)
            
            isHighSpeedMode = true
            return
        }
        
        if isHighSpeedMode == true {
            UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveLinear, animations: {() -> Void in
                self.view.backgroundColor = UIColor.colorFromHex(hexString: "#1F1F1F")
            }, completion: nil)
            //警告推出极速模式
            let tip = TipBubble()
            tip.BubbackgroundColor = UIColor.colorFromHex(hexString: "#FFFFFF").withAlphaComponent(0.6)
            tip.TipTextColor = UIColor.black
            tip.TipContent = "普通模式"
            self.view.addSubview(tip)
            tip.show(dalay: 1.5)
            
            
            isHighSpeedMode = false
            return
        }
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
            
            //判断是否登陆
            let defaults = UserDefaults.standard
            if let LogInStatus = defaults.value(forKey: "LogInStatus"),
                String(describing: LogInStatus) == "yes"{
            }else{
                let tip = TipBubble()
                tip.BubbackgroundColor = UIColor.colorFromHex(hexString: "#FFFFFF").withAlphaComponent(0.6)
                tip.TipTextColor = UIColor.black
                tip.TipContent = "您未登陆,骑行记录将不会被保存"
                self.view.addSubview(tip)
                tip.show(dalay: 2)
            }
            
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
        
       if ifDashVCAppear == true {
            self.RideBtn.isEnabled = false
            self.EndRideBtn.isEnabled = true
        }
        
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
        
        if ifDashVCAppear == true {
            RideBtn.isEnabled = true
            EndRideBtn.isEnabled = false
        }
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
        
        let defaults = UserDefaults.standard
        if let LogInStatus = defaults.value(forKey: "LogInStatus"),
            String(describing: LogInStatus) == "yes"{
            }else{
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
                if Double((MotionData?.rotationRate.y)!) > 10.0{
                    self.showSendAlrt()
                }
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
        
        if ifDashVCAppear == true{
            //时间函数
            sec += 1
            if sec >= 60{
                min += 1
                sec = 0
            }
            var sst = String(sec)
            var mst = String(min)
            if sec < 10 {
                sst = "0" + sst
            }
            if min < 10 {
                mst = "0" + mst
            }
            timeLabel.text = mst + ":" + sst
        }
    }
    
    func showSendAlrt(){
        //如果显示了就直接返回
        if alertAppear == true {return}
        
        //数据库获取数据
        let defaults = UserDefaults.standard
        let UserID = String(describing: defaults.value(forKey: "UserID")!)
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("userID = \(UserID)")[0]
        
        let phone = user.userEmergencyPhone
        
        alertController = UIAlertController(title: "应急短信即将发送至：\(phone)", message: "倒计时:\(countdown)秒", preferredStyle: .alert)
        let messageAction = UIAlertAction(title: "发送", style: .default , handler: { (action:UIAlertAction)in
            //显示状态清零
            self.getDeviceLocation()
            self.countDownTimer.invalidate()
            self.alertAppear = false
            self.countdown = 30
        })
        let phoneAction = UIAlertAction(title: "电话联系", style: .default , handler: { (action:UIAlertAction)in
            //显示状态清零
            let urlString = "tel://\(phone)"
            if let url = URL(string: urlString) {
                //根据iOS系统版本，分别处理
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],completionHandler: nil)
                    self.countDownTimer.invalidate()
                } else {
                    UIApplication.shared.openURL(url)
                    self.countDownTimer.invalidate()
                }
            }
            self.alertAppear = false
            self.countdown = 30
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel , handler: {(action:UIAlertAction)in
            //显示状态清零
            self.alertAppear = false
            self.countdown = 30
            
        })
        alertController.addAction(messageAction)
        alertController.addAction(phoneAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
       
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        
        alertAppear = true
    }
    
    @objc func countDown(){
        countdown -= 1
        if countdown == 0{
            //发送，time停止
            getDeviceLocation()
            countDownTimer.invalidate()
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.message = "倒计时:\(countdown)秒"
    }
    
    
    /*
     *  发送短信
     *  独立定位管理：不会被持续定位打断
     */
    func getDeviceLocation() {
        
        let SmslocationManager = AMapLocationManager()
        SmslocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        SmslocationManager.locatingWithReGeocode = true
        SmslocationManager.reGeocodeTimeout = 10
        SmslocationManager.locationTimeout = 10
        
        SmslocationManager.requestLocation(withReGeocode: false, completionBlock: { (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            
            if let location = location {
                self.address = "经纬度:\(location.coordinate.longitude),\(location.coordinate.latitude)"
                //逆地理
                self.ReverseGeoCoding(coordinate: location.coordinate)
            }else if self.locationTimes < 5{
                self.locationTimes += 1
                self.getDeviceLocation()
            }
        })
    }
    
    //逆地理编码
    func ReverseGeoCoding(coordinate: CLLocationCoordinate2D) -> Void {
        
        let request = AMapReGeocodeSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        request.requireExtension = true
        
        search?.aMapReGoecodeSearch(request)
    }
    
    //发送短信
    func netSendMessage(address: String) {
        
        //数据库获取数据
        let defaults = UserDefaults.standard
        let UserID = String(describing: defaults.value(forKey: "UserID")!)
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("userID = \(UserID)")[0]
        
        let phone = user.userEmergencyPhone
        let name = user.userEmergencyMessage
        
        
        let queue = DispatchQueue(label: "BikeDemo.mclarenyang")
        queue.sync {
            let parameters: Parameters = [
                "phone": phone,
                "name": name,
                "address": address
            ]
            //网络请求
            let url = MenuViewController.APIURLHead + "sms/send"
            Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
                request in
                if let value = request.result.value{
                    let json = JSON(value)
                    let code = json[]["code"]
                    print(json)
                    if code == 200{
                        // to do 成功提示
                        NSLog("发送成功")
                    }else{
                        // to do 失败提示
                        NSLog("发送失败")
                    }
                }
            }
        }
        //结束行程
        self.endRecordRideData()
    }
}

extension DashBoardViewController: AMapLocationManagerDelegate, UIAccelerometerDelegate, AMapSearchDelegate{
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
        NSLog("位置刷新")
        if ifDashVCAppear == true{
            getSystemLocationInfo(speed: location.speed * 3.6)
            altitudeLabel.text = String(format: "%.1f", location.altitude) + "∆"
        }
        //内存中写入数据
        writeRideDate(location: location)
    }
    
    //逆地理解析回调
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        //解析逆地理返回值
        if response.regeocode != nil {
            var sendAddress = ""
            if request.location != nil{
                sendAddress = response.regeocode.formattedAddress + "附近，" + "经纬度:\(request.location.longitude),\(request.location.latitude)"
            }else{
                sendAddress = response.regeocode.formattedAddress + "附近，" + self.address
            }
            self.netSendMessage(address: sendAddress)
        }
    }
}

//扩展获取显示的VC
public extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    public static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}

