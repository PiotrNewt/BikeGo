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
    
    
    @IBAction func BackBtnClick(_ sender: Any) {
        hero.dismissViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SignInLabel.isUserInteractionEnabled = true
        let SignInGesture = UITapGestureRecognizer(target: self , action: #selector(selectSignInLabel))
        SignInLabel.addGestureRecognizer(SignInGesture)

        //用户注册参数：[userName,userPassword,userEmergencyPhone(正则)]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func selectSignInLabel() -> Void {
        let signInVC = (UIStoryboard(name: "LogIn", bundle: nil).instantiateViewController(withIdentifier: "SignIn") as? SignInViewController)!
        hero.replaceViewController(with: signInVC)
    }

}
