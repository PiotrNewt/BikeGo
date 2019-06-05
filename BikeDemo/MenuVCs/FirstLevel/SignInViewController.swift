//
//  SignInViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/3.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import TextFieldEffects

class SignInViewController: UIViewController {

    
    @IBOutlet weak var SignUpLabel: UILabel!
    
    var NameTF = HoshiTextField()
    var PasswordTF = HoshiTextField()
    
    
    @IBAction func BackBtnClick(_ sender: Any) {
        hero.dismissViewController()
    }
    
    @IBAction func SignInClick(_ sender: Any) {
        if NameTF.text != "" && PasswordTF.text != "" {
            netSignin()
        }else{
            NSLog("输入为空")
            let tip = TipBubble()
            tip.TipContent = "请输入完整信息"
            self.view.addSubview(tip)
            tip.show(dalay: 2)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //self.hero.isEnabled = true
        
        SignUpLabel.isUserInteractionEnabled = true
        let SignUpGesture = UITapGestureRecognizer(target: self , action: #selector(selectSignUpLabel))
        SignUpLabel.addGestureRecognizer(SignUpGesture)
        
        //添加键盘收回手势
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(keyboardComeback)))
        
        //修饰TF
        let nframe = CGRect(x:UIScreen.main.bounds.width / 2 - 122, y: UIScreen.main.bounds.height / 2 - 91, width: 244, height: 50)
        NameTF.frame = nframe
        NameTF.placeholder = "昵称"
        NameTF.placeholderColor = UIColor.colorFromHex(hexString: "#9B9B9B")
        NameTF.borderInactiveColor = UIColor.colorFromHex(hexString: "#979797")
        NameTF.borderActiveColor = UIColor.colorFromHex(hexString: "#6A39F7")
        self.view.addSubview(NameTF)
        
        let pframe = CGRect(x:UIScreen.main.bounds.width / 2 - 122, y: UIScreen.main.bounds.height / 2 - 25, width: 244, height: 50)
        PasswordTF.frame = pframe
        PasswordTF.placeholder = "密码"
        PasswordTF.placeholderColor = UIColor.colorFromHex(hexString: "#9B9B9B")
        PasswordTF.borderInactiveColor = UIColor.colorFromHex(hexString: "#979797")
        PasswordTF.borderActiveColor = UIColor.colorFromHex(hexString: "#6A39F7")
        PasswordTF.isSecureTextEntry = true
        self.view.addSubview(PasswordTF)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func netSignin() {
       
        let parameters: Parameters = [
            "userName": NameTF.text!,
            "userPassword": PasswordTF.text!
        ]
        //网络请求
        let url = MenuViewController.APIURLHead + "user/login"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            request in
            if let value = request.result.value{
                let json = JSON(value)
                let code = json[]["code"]
                if code == 200{
                    NSLog("登陆成功")
                    //刷新用户信息
                    self.netGetUserInfo(userID: Int(String(describing: json[]["uid"]))!)
                }else{
                    NSLog("登陆失败")
                    let tip = TipBubble()
                    tip.TipContent = "用户名或密码错误"
                    self.view.addSubview(tip)
                    tip.show(dalay: 2)
                }
            }
        }
    }
    
     func netGetUserInfo(userID: Int) {
        
        let parameters: Parameters = [
            "uid": userID,
        ]
        //网络请求
        let url = MenuViewController.APIURLHead + "user/getUser"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            request in
            if let value = request.result.value{
                let json = JSON(value)
                let code = json[]["code"]
                if code == 200{
                    NSLog("获取成功")
                    let user = User()
                    user.userID = Int(String(describing:json[]["user"]["userId"]))!
                    user.userName = String(describing: json[]["user"]["userName"])
                    user.userEmergencyPhone = String(describing: json[]["user"]["userEmergencyPhone"])
                    //头像
                    let imageURL = NSURL(string: "\(json[]["user"]["userImg"])")
                    let data = try? Data(contentsOf: imageURL! as URL)
                    user.userImg = data! as NSData
                    
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(user, update: true)
                    }
                    print("数据库地址：\(realm.configuration.fileURL!)")
                    
                    //存储ID
                    let defaults = UserDefaults.standard
                    defaults.set(String(describing: userID), forKey: "UserID")
                    defaults.set("yes", forKey: "LogInStatus")
                    
                    let personalVC = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Personal") as? PersonalViewController)!
                    self.hero.replaceViewController(with: personalVC)
                    
                }else{
                    // to do 获取失败警告提示
                    NSLog("获取失败")
                    let tip = TipBubble()
                    tip.TipContent = "用户信息拉取失败"
                    self.view.addSubview(tip)
                    tip.show(dalay: 2)
                }
            }
        }
    }
    
    //收回键盘
    @objc func keyboardComeback() {
        NameTF.resignFirstResponder()
        PasswordTF.resignFirstResponder()
    }
    
    @objc func selectSignUpLabel() -> Void {
        let signUpVC = (UIStoryboard(name: "LogIn", bundle: nil).instantiateViewController(withIdentifier: "SignUp") as? SignUpViewController)!
        hero.replaceViewController(with: signUpVC)
    }

}
