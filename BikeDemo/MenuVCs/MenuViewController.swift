//
//  MenuViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/3.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import RealmSwift

class MenuViewController: UIViewController {
    
    static let APIURLHead = "http://120.77.87.78:8080/cycle/api/"
    
    //storyboard
    @IBOutlet weak var HeadPortraitIamgeView: UIImageView!
    @IBOutlet weak var HelloLabel: UILabel!
    @IBOutlet weak var FriendsBtn: UIButton!
    @IBOutlet weak var MessageBtn: UIButton!
    @IBOutlet weak var RideDataBtn: UIButton!
    @IBOutlet weak var AboutBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true
        
        HeadPortraitIamgeView.layer.masksToBounds = true
        HeadPortraitIamgeView.layer.cornerRadius = 45
        HeadPortraitIamgeView.isUserInteractionEnabled = true
        let headImageGesture = UITapGestureRecognizer(target: self, action: #selector(selectHeadImageOrHelloLabel))
        HeadPortraitIamgeView.addGestureRecognizer(headImageGesture)
        HelloLabel.isUserInteractionEnabled = true
        HelloLabel.addGestureRecognizer(headImageGesture)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //判断用户是否登陆 -> 调整UI
        let defaults = UserDefaults.standard
        let LogInStatus = String(describing: defaults.value(forKey: "LogInStatus")!)
        if LogInStatus == "yes" {
            //如果用户登录过 -> 彩色UI / 从Realm获取用户的头像 ／获取用户的昵称
            let UserID = String(describing: defaults.value(forKey: "UserID")!)
            let realm = try! Realm()
            let user = realm.objects(User.self).filter("userID = \(UserID)")[0]
            
            HeadPortraitIamgeView.image = UIImage(data: user.userImg as Data)
            HelloLabel.text = "Hi,\(user.userName)"
            FriendsBtn.isEnabled = true
            MessageBtn.isEnabled = true
            RideDataBtn.isEnabled = true
            
            print("数据库地址：\(realm.configuration.fileURL!)")
            
        } else {
            //如果用户还没有登录 -> 按钮失效
            HeadPortraitIamgeView.image = #imageLiteral(resourceName: "HeadPortraitIamge")
            HelloLabel.text = "sign in / sign up"
            FriendsBtn.isEnabled = false
            MessageBtn.isEnabled = false
            RideDataBtn.isEnabled = false
            FriendsBtn.setImage(#imageLiteral(resourceName: "FriendsBtn"), for: UIControlState.normal)
            MessageBtn.setImage(#imageLiteral(resourceName: "MessageBtn"), for: UIControlState.normal)
            RideDataBtn.setImage(#imageLiteral(resourceName: "RideDateBtn"), for: UIControlState.normal)
        }
        
    }
 
    //点击事件
    @objc func selectHeadImageOrHelloLabel(){
        if HelloLabel.text == "sign in / sign up" {
            // 跳转到登录页面
            let signInVC = (UIStoryboard(name: "LogIn", bundle: nil).instantiateViewController(withIdentifier: "SignIn") as? SignInViewController)!
            hero.modalAnimationType = .zoom
            self.present(signInVC, animated: true, completion: nil)
        } else {
            // 跳转到个人主页
        }
    }

}
