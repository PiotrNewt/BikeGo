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

class SignUpViewController: UIViewController {

    @IBOutlet weak var SignInLabel: UILabel!
    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var PhoneNumberTF: UITextField!
    
    
    @IBAction func BackBtnClick(_ sender: Any) {
        hero.dismissViewController()
    }
    
    @IBAction func SignUpBtnClick(_ sender: Any) {
        if NameTF.text != "" && PasswordTF.text != "" && PhoneNumberTF.text != "" {
            netSignUp()
        }else{
            NSLog("输入为空")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SignInLabel.isUserInteractionEnabled = true
        let SignInGesture = UITapGestureRecognizer(target: self , action: #selector(selectSignInLabel))
        SignInLabel.addGestureRecognizer(SignInGesture)
        
        NameTF.delegate = self
        
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
                    //警告已被注册
                    NSLog("用户名被占用")
                    return
                }
            }
        }
    }
    
    @objc func selectSignInLabel() -> Void {
        let signInVC = (UIStoryboard(name: "LogIn", bundle: nil).instantiateViewController(withIdentifier: "SignIn") as? SignInViewController)!
        hero.replaceViewController(with: signInVC)
    }

}

extension SignUpViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        netJudgeNameSaved()
    }
}
