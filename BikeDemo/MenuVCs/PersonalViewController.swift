//
//  PersonalViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/7.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class PersonalViewController: UIViewController {
    
    var articles: [Article] = [Article]() {
        didSet {CollectionView.reloadData()}
    }

    @IBOutlet weak var HeadPortraitIamgeView: UIImageView!
    @IBOutlet weak var HelloLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var CollectionView: UICollectionView!
    
    
    
    @IBAction func BackBtnClick(_ sender: Any) {
        hero.dismissViewController()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        
        CollectionView.delegate = self
        CollectionView.dataSource = self
        netLoadAriticle()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateLeaveView()
    }
    
    func updateLeaveView() {
        
        let defaults = UserDefaults.standard
        let UserID = String(describing: defaults.value(forKey: "UserID")!)
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("userID = \(UserID)")[0]
        
        HeadPortraitIamgeView.image = UIImage(data: user.userImg as Data)
        HelloLabel.text = "Hello,\(user.userName)"
        
        // 日期
        let now = Date()
        let dformatter = DateFormatter()
        dformatter.dateFormat = "MM月dd日 E"
        DateLabel.text = "今天是\(dformatter.string(from: now))"
        
    }
    
    func netLoadAriticle(){
        let defaults = UserDefaults.standard
        let UserID = String(describing: defaults.value(forKey: "UserID")!)
        
        let parameters: Parameters = [
            "userId": UserID,
            "writerId": UserID
            ]
        
        //网络请求
        let url = MenuViewController.APIURLHead + "article/getHis"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            request in
            if let value = request.result.value{
                let json = JSON(value)
                let code = json[]["code"]
                if code == 200 {
                    let arts = json[]["articles"]
                    for (_ , art):(String, JSON) in arts{
                        let user = User()
                        user.userID = art[]["user"]["userId"].int!
                        user.userName = art[]["user"]["userName"].string!
                        
                        let imageURL = NSURL(string: art[]["user"]["userImg"].string!)
                        user.userImg = try! Data(contentsOf: imageURL! as URL) as NSData
                        
                        let article = Article()
                        article.articleID = art[]["articleId"].int!
                        article.user = user
                        article.articleContent = art[]["articleContent"].string!
                        for (_ , img):(String, JSON) in art[]["articleImgs"]{
                            article.articleImgs.append(img[].string!)
                        }
                        article.date = art[]["date"].string!
                        article.time = art[]["time"].string!
                        article.likeNum = art[]["likeNum"].int!
                        article.commentNum = art[]["commentNum"].int!
                        article.likeArticle = art[]["likeArticle"].bool!
                        
                        self.articles.append(article)
                    }
                }
            }
        }
    }
}


extension PersonalViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "collItem", for: indexPath) as? ArticleCell)!
        cell.article = articles[indexPath.item]
        cell.backgroundColor = UIColor.gray
        return cell
    }
    
    
}

