//
//  AddArticleViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/12.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class AddArticleViewController: UIViewController {
    
    var images: [UIImage] = [UIImage](){
        didSet{
            self.ArticleImgCoLLView.reloadData()
        }
    }
    
    @IBOutlet weak var UserAvatarImgView: UIImageView!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var ArticleContentTV: UITextView!
    @IBOutlet weak var ArticleImgCoLLView: UICollectionView!
    
    @IBAction func BackBtnClick(_ sender: Any) {
        hero.dismissViewController()
    }
    
    @IBAction func AddBtnClick(_ sender: Any) {
        if ArticleContentTV.text == "" {
            // 错误提示
        }else{
            //netPublish()
            netUploadImage(ArticleId: "140")
        }
    }
    
    @IBAction func CameraBtnClick(_ sender: Any) {
        addImage()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        
        ArticleImgCoLLView.delegate = self
        ArticleImgCoLLView.dataSource = self
        
        images.removeAll()
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
    
    //网络请求
    func netPublish() {
        let defaults = UserDefaults.standard
        let userID = String(describing: defaults.value(forKey: "UserID")!)
        
        let parameters: Parameters = [
            "userId": userID,
            "content": ArticleContentTV.text
            ]
        //网络请求
        let url = MenuViewController.APIURLHead + "article/publish"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            request in
            if let value = request.result.value{
                let json = JSON(value)
                let code = json[]["code"]
                if code == 200{
                    //to do 发布成功
                    NSLog("发布成功")
                    //self.netUploadImage() 检查一下有没有图片
                }else{
                    //to do 错误处理
                }
            }
        }
    }
    
    func netUploadImage(ArticleId: String) {
        let defaults = UserDefaults.standard
        let userID = String(describing: defaults.value(forKey: "UserID")!)
        
        let parameters: Parameters = [
            "userId": userID,
            "articleId": ArticleId
        ]
        
        //网络请求
        let url = MenuViewController.APIURLHead + "img/article"
    
        Alamofire.upload(multipartFormData: {
            multipartFormData in
            
            for (key, value) in parameters {
                let str: String = value as! String
                let data: Data = str.data(using:String.Encoding.utf8)!
                multipartFormData.append(data, withName: key)
            }
            
            for index in 0...self.images.count - 1{
                multipartFormData.append(UIImagePNGRepresentation(self.images[index])!, withName: "image\(index)")
            }
            },to: url,
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
                                        //to do 怕是上传失败了哦
                                }
                            }
                        }
                    case .failure(let encodingError):
                    print(encodingError)
                }
            })
    }
    
    func addImage() {
        
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
    
    // 相册方法
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

}

extension AddArticleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.images.append(image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "AddImageItem", for: indexPath) as! ImageCell)
        cell.Image.image = images[indexPath.item]
        return cell
    }
    
    
}

