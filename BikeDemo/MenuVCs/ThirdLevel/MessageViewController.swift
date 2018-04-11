//
//  MessageViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/11.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import RealmSwift

class MessageViewController: UIViewController {

    @IBOutlet weak var PhoneNumTF: UITextField!
    @IBOutlet weak var MessageContentTV: UITextView!
    
    @IBAction func BackBtnClick(_ sender: Any) {
        hero.dismissViewController()
    }
    
    @IBAction func SendBtnClick(_ sender: Any) {
    }
    @IBAction func SaveBtnClick(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let UserID = String(describing: defaults.value(forKey: "UserID")!)
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("userID = \(UserID)")[0]
        
        self.PhoneNumTF.text = user.userEmergencyPhone
        self.MessageContentTV.text = user.userEmergencyMessage
    }
    

}
