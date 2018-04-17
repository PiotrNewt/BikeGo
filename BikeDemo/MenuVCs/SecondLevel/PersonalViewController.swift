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
    
    var articles: [Article] = [Article]()

    @IBOutlet weak var HeadPortraitIamgeView: UIImageView!
    @IBOutlet weak var HelloLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var CollectionView: UICollectionView!
    
    @IBAction func BackBtnClick(_ sender: Any) {
        hero.dismissViewController()
    }
    
    @IBAction func AddArticleBtnClick(_ sender: Any) {
        let addArticleVC = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddArticle") as? AddArticleViewController)!
        self.show(addArticleVC, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        
        HeadPortraitIamgeView.layer.masksToBounds = true
        HeadPortraitIamgeView.layer.cornerRadius = 45
        HeadPortraitIamgeView.isUserInteractionEnabled = true
        let headImageGesture = UITapGestureRecognizer(target: self, action: #selector(replaceHeadImg))
        HeadPortraitIamgeView.addGestureRecognizer(headImageGesture)
        
        CollectionView.delegate = self
        CollectionView.dataSource = self
        
        updateLeaveView()
        netLoadAriticle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
    
    //跳转
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowArticleDetail",
            let currentCell = sender as? ArticleCell,
            let currentCellIndex = CollectionView.indexPath(for: currentCell),
            let articleDVC = segue.destination as? ArticleDetailViewController{
                //动画基本值
                articleDVC.view.hero.id = currentCell.hero.id
                //传整个articel
                articleDVC.article = self.articles[currentCellIndex.item]
        }
    }
    
    //修改头像
    @objc func replaceHeadImg() {
        let alert = UIAlertController(title: "添加照片", message: "", preferredStyle: .actionSheet)
        let photoAction = UIAlertAction(title: "相册", style: .default , handler: { (action:UIAlertAction)in
            self.photo()
        })
        let cameraAction = UIAlertAction(title: "相机", style: .default , handler: { (action:UIAlertAction)in
            self.camera()
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel , handler: nil)
        
        alert.addAction(photoAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //相册方法
    func photo() {
        
        let pick:UIImagePickerController = UIImagePickerController()
        pick.delegate = self
        pick.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(pick, animated: true, completion: nil)
        
    }
    
    //相机方法
    func camera() {
        
        guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) == true else{
            //to do 警告相机无法使用
            NSLog("相机无法使用")
            return
        }
        
        let pick:UIImagePickerController = UIImagePickerController()
        pick.delegate = self
        pick.sourceType = UIImagePickerControllerSourceType.camera
        self.present(pick, animated: true, completion: nil)
        
    }
    
    func netChangeHeadImg(image: UIImage) {
        let defaults = UserDefaults.standard
        let UserID = String(describing: defaults.value(forKey: "UserID")!)
        //参数
        let parameters: Parameters = [
            "uid": UserID
        ]
        //网络请求
        let url = MenuViewController.APIURLHead + "img/changeUser"
        
        Alamofire.upload(multipartFormData: {
            multipartFormData in
            
            for (key, value) in parameters {
                let str: String = value as! String
                let data: Data = str.data(using:String.Encoding.utf8)!
                multipartFormData.append(data, withName: key)
            }
            
            multipartFormData.append(UIImagePNGRepresentation(image)!, withName: "userImg", fileName: "HeadImage", mimeType: "image/png")
            
        },to: url, headers: nil,
          encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON {
                    request in
                    NSLog("怕是添加成功了哦")
                    if let value = request.result.value{
                        let json = JSON(value)
                        print(json)
                        let code = json[]["code"]
                        if code != 200{
                            //to do 头像修改失败
                        }
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }

    
    func netLoadAriticle(){
        
        let defaults = UserDefaults.standard
        let UserID = String(describing: defaults.value(forKey: "UserID")!)
        
        let parameters: Parameters = [
            "userId": UserID,
            "writerId": UserID
            ]
        //清空
        self.articles.removeAll()
        //网络请求
        let url = MenuViewController.APIURLHead + "article/getHis"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            request in
            // 后台修改
            let queue = DispatchQueue(label: "BikeDemo.mclarenyang", attributes: .concurrent)
            queue.async {
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
                        article.articleID = art[]["articleId"].int!
                        
                        self.articles.append(article)
                    }
                    
                    DispatchQueue.main.async {
                        self.CollectionView.reloadData()
                    }
                }
            }
        }}
    }
}


extension PersonalViewController: UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "collItem", for: indexPath) as? ArticleCell)!
        cell.article = articles[indexPath.item]
        cell.backgroundColor = UIColor.gray
        return cell
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.HeadPortraitIamgeView.image = image
        
        netChangeHeadImg(image: image)
        //存到数据库中 - 异步修改
        let queue = DispatchQueue(label: "BikeDemo.mclarenyang")
        queue.async {
            let defaults = UserDefaults.standard
            let UserID = String(describing: defaults.value(forKey: "UserID")!)
            
            let realm = try! Realm()
            let user = realm.objects(User.self).filter("userID = \(UserID)")[0]
            
            try! realm.write {
                user.userImg = UIImagePNGRepresentation(image)! as NSData
                realm.add(user, update: true)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}

