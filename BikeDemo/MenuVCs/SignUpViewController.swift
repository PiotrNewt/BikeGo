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

    override func viewDidLoad() {
        super.viewDidLoad()

        //用户注册参数：[userName,userPassword,userEmergencyPhone(正则)]
        //设置登录代理注册接收注册的参数，回调直接执行登录按钮的fanc
        //登陆到注册的动画直接用hero -> storyboard
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
