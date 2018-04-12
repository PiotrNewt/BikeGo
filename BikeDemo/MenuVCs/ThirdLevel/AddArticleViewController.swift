//
//  AddArticleViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/12.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import RealmSwift

class AddArticleViewController: UIViewController {
    
    @IBOutlet weak var UserAvatarImgView: UIImageView!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var ArticleContentTV: UITextView!
    @IBOutlet weak var ArticleImgCoLLView: UICollectionView!
    
    @IBAction func BackBtnClick(_ sender: Any) {
        hero.dismissViewController()
    }
    
    @IBAction func AddBtnClick(_ sender: Any) {
    }
    
    @IBAction func CameraBtnClick(_ sender: Any) {
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
        
        UserAvatarImgView.image = UIImage(data: user.userImg as Data)
        UserNameLabel.text = user.userName
    }

}
