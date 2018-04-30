//
//  MessageViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/11.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import RealmSwift
import TextFieldEffects
import Alamofire
import SwiftyJSON

class MessageViewController: UIViewController {
    
    var PhoneNumTF = HoshiTextField()
    var NameTF = HoshiTextField()
    let search = AMapSearchAPI()
    
    //定位阙值
    var locationTimes = 0
    
    //保险地址
    var address = ""
    
    @IBOutlet weak var MessageView: UIView!
    @IBOutlet weak var SendBtn: UIButton!
    
    
    
    @IBAction func BackBtnClick(_ sender: Any) {
        hero.dismissViewController()
    }
    
    @IBAction func SendBtnClick(_ sender: Any) {
        if PhoneNumTF.text == "" || NameTF.text == "" {
            //to-do 报错
        }else{
            self.sendMessageWithDeviceLocation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        search?.delegate = self
        
        //添加键盘收回手势
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(keyboardComeback)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTF()
    }
    
    func setTF() {
        //self.view.addSubview(MessageView)
        
        //修饰TF
        let pframe = CGRect(x:MessageView.frame.width / 2 - 100, y: MessageView.frame.width / 2 - 25 - 60, width: 200, height: 50)
        PhoneNumTF.frame = pframe
        PhoneNumTF.placeholder = "电话"
        PhoneNumTF.placeholderColor = UIColor.colorFromHex(hexString: "#9B9B9B")
        PhoneNumTF.borderInactiveColor = UIColor.colorFromHex(hexString: "#979797")
        PhoneNumTF.borderActiveColor = UIColor.colorFromHex(hexString: "#6A39F7")
        self.MessageView.addSubview(PhoneNumTF)
        
        let nframe = CGRect(x:MessageView.frame.width / 2 - 100, y: MessageView.frame.width / 2 - 20, width: 200, height: 50)
        NameTF.frame = nframe
        NameTF.placeholder = "名称"
        NameTF.placeholderColor = UIColor.colorFromHex(hexString: "#9B9B9B")
        NameTF.borderInactiveColor = UIColor.colorFromHex(hexString: "#979797")
        NameTF.borderActiveColor = UIColor.colorFromHex(hexString: "#6A39F7")
        self.MessageView.addSubview(NameTF)
        
        self.MessageView.addSubview(self.SendBtn)
        
        //数据库获取数据
        let defaults = UserDefaults.standard
        let UserID = String(describing: defaults.value(forKey: "UserID")!)
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("userID = \(UserID)")[0]
        
        self.PhoneNumTF.text = user.userEmergencyPhone
        self.NameTF.text = user.userEmergencyMessage
    }
    
    func saveUserEmegecyInfo(){
        
        let defaults = UserDefaults.standard
        let UserID = String(describing: defaults.value(forKey: "UserID")!)
        
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("userID = \(UserID)")[0]
        
        try! realm.write {
            user.userEmergencyPhone = PhoneNumTF.text!
            user.userEmergencyMessage = NameTF.text!
            realm.add(user, update: true)
        }
    }
    
    //单次定位
    func sendMessageWithDeviceLocation() {
        
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
                self.sendMessageWithDeviceLocation()
            }
        })
    }
    
    //发送短信
    func netSendEMessage(phone:String, name:String, address: String){
        
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
                            // to do 失败提示
                            NSLog("发送成功")
                            //保存数据
                            self.saveUserEmegecyInfo()
                        }else{
                            // to do 失败提示
                            NSLog("发送失败")
                        }
                    }
                }
            }
    }
    
    //逆地理编码
    func ReverseGeoCoding(coordinate: CLLocationCoordinate2D) -> Void {
    
        let request = AMapReGeocodeSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        request.requireExtension = true
    
        search?.aMapReGoecodeSearch(request)
}
    
    //收回键盘
    @objc func keyboardComeback() {
        NameTF.resignFirstResponder()
        PhoneNumTF.resignFirstResponder()
    }

}

extension MessageViewController: AMapSearchDelegate{
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
            self.netSendEMessage(phone: self.PhoneNumTF.text!, name: self.NameTF.text!, address: sendAddress)
            //
            print(sendAddress)
        }
    }
}
