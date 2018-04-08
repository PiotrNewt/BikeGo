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

class SignInViewController: UIViewController {

    
    @IBOutlet weak var SignUpLabel: UILabel!
    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    
    
    @IBAction func BackBtnClick(_ sender: Any) {
        hero.dismissViewController()
    }
    
    @IBAction func SignInClick(_ sender: Any) {
        if NameTF.text != "" && PasswordTF.text != "" {
            netSignin()
        }else{
            NSLog("输入为空")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //self.hero.isEnabled = true
        
        SignUpLabel.isUserInteractionEnabled = true
        let SignUpGesture = UITapGestureRecognizer(target: self , action: #selector(selectSignUpLabel))
        SignUpLabel.addGestureRecognizer(SignUpGesture)

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
                    
                    self.hero.dismissViewController()
                    
                }else{
                    NSLog("获取失败")
                }
            }
        }
    }
    
    @objc func selectSignUpLabel() -> Void {
        let signUpVC = (UIStoryboard(name: "LogIn", bundle: nil).instantiateViewController(withIdentifier: "SignUp") as? SignUpViewController)!
        hero.replaceViewController(with: signUpVC)
    }

}
