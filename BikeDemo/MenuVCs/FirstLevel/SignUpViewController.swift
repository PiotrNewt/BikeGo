//
//  SignUpViewController.swift
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

class SignUpViewController: UIViewController {

    @IBOutlet weak var SignInLabel: UILabel!
    
    var NameTF = HoshiTextField()
    var PasswordTF = HoshiTextField()
    var PhoneNumberTF = HoshiTextField()
    
    
    @IBAction func BackBtnClick(_ sender: Any) {
        hero.dismissViewController()
    }
    
    @IBAction func SignUpBtnClick(_ sender: Any) {
        if NameTF.text != "" && PasswordTF.text != "" && PhoneNumberTF.text != "" {
            netSignUp()
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
        
        SignInLabel.isUserInteractionEnabled = true
        let SignInGesture = UITapGestureRecognizer(target: self , action: #selector(selectSignInLabel))
        SignInLabel.addGestureRecognizer(SignInGesture)
        
        NameTF.delegate = self
        
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
        PasswordTF.isSecureTextEntry = false
        self.view.addSubview(PasswordTF)
        
        let eframe = CGRect(x:UIScreen.main.bounds.width / 2 - 122, y: UIScreen.main.bounds.height / 2 + 41, width: 244, height: 50)
        PhoneNumberTF.frame = eframe
        PhoneNumberTF.placeholder = "应急电话"
        PhoneNumberTF.placeholderColor = UIColor.colorFromHex(hexString: "#9B9B9B")
        PhoneNumberTF.borderInactiveColor = UIColor.colorFromHex(hexString: "#979797")
        PhoneNumberTF.borderActiveColor = UIColor.colorFromHex(hexString: "#6A39F7")
        self.view.addSubview(PhoneNumberTF)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func netSignUp() {
        let parameters: Parameters = [
            "userName": NameTF.text!,
            "userPassword": PasswordTF.text!,
            "userEmergencyPhone": PhoneNumberTF.text!
        ]
        //网络请求
        let url = MenuViewController.APIURLHead + "user/register"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            request in
                if let value = request.result.value{
                    let json = JSON(value)
                    let code = json[]["code"]
                    if code == 200{
                        NSLog("注册成功")
                        self.netGetUserInfo(userID: Int(String(describing: json[]["uid"]))!)
                    }else{
                        NSLog("注册失败")
                        let tip = TipBubble()
                        tip.TipContent = "注册失败"
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
                    NSLog("获取失败")
                }
            }
        }
    }
    
    func netJudgeNameSaved() {
        let parameters: Parameters = [
            "userName": NameTF.text!,
            ]
        //网络请求
        let url = MenuViewController.APIURLHead + "user/nameSaved"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            request in
            if let value = request.result.value{
                let json = JSON(value)
                let judgement = json[]["hasSame"]
                guard judgement != true else {
                    //to do 警告已被注册
                    NSLog("用户名被占用")
                    let tip = TipBubble()
                    tip.TipContent = "用户名已被注册"
                    self.view.addSubview(tip)
                    tip.show(dalay: 2)
                    return
                }
            }
        }
    }
    
    @objc func selectSignInLabel() -> Void {
        let signInVC = (UIStoryboard(name: "LogIn", bundle: nil).instantiateViewController(withIdentifier: "SignIn") as? SignInViewController)!
        hero.replaceViewController(with: signInVC)
    }
    
    //收回键盘
    @objc func keyboardComeback() {
        NameTF.resignFirstResponder()
        PasswordTF.resignFirstResponder()
        PhoneNumberTF.resignFirstResponder()
    }

}

extension SignUpViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        netJudgeNameSaved()
    }
}
