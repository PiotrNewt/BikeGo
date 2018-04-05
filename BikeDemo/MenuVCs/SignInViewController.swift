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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SignUpLabel.isUserInteractionEnabled = true
        let SignUpGesture = UITapGestureRecognizer(target: self , action: #selector(selectSignUpLable))
        SignUpLabel.addGestureRecognizer(SignUpGesture)
        
        
        //用户登录参数 ：[userName, userPassword]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func selectSignUpLable() -> Void {
        let signUpVC = (UIStoryboard(name: "LogIn", bundle: nil).instantiateViewController(withIdentifier: "SignUp") as? SignUpViewController)!
        self.navigationController?.pushViewController(signUpVC, animated: false)
    }

}
