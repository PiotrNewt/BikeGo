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

class MessageViewController: UIViewController {
    
    var PhoneNumTF = HoshiTextField()
    var NameTF = HoshiTextField()
    
    
    @IBOutlet weak var MessageView: UIView!
    @IBOutlet weak var SendBtn: UIButton!
    
    
    
    @IBAction func BackBtnClick(_ sender: Any) {
        hero.dismissViewController()
    }
    
    @IBAction func SendBtnClick(_ sender: Any) {
        if saveUserEmegecyInfo() != true{
            // to do 报错
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        
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
    
    func saveUserEmegecyInfo() -> Bool{
        
        if PhoneNumTF.text == "" || NameTF.text == "" {
            return false
        }
        
        let defaults = UserDefaults.standard
        let UserID = String(describing: defaults.value(forKey: "UserID")!)
        
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("userID = \(UserID)")[0]
        
        try! realm.write {
            user.userEmergencyPhone = PhoneNumTF.text!
            user.userEmergencyMessage = NameTF.text!
            realm.add(user, update: true)
        }
        DashBoardViewController.sendMessageWithDeviceLocation(phone: self.PhoneNumTF.text!, name: self.NameTF.text!)
        return true
    }
    
    //收回键盘
    @objc func keyboardComeback() {
        NameTF.resignFirstResponder()
        PhoneNumTF.resignFirstResponder()
    }

}
