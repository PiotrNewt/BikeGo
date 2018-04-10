//
//  ArticleCell.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/7.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ArticleCell: UICollectionViewCell {
    
    @IBOutlet weak var TopImageView: UIImageView!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var LikeBtn: UIButton!
    @IBOutlet weak var CommentBtn: UIButton!
    @IBOutlet weak var ContentLabel: UILabel!
    
    //to do 两个按钮的跳转
    @IBAction func LikeBtnClick(_ sender: Any) {
        let defaults = UserDefaults.standard
        let UserID = String(describing: defaults.value(forKey: "UserID")!)
        netChangeLiekArticle(userID: Int(UserID)!, articleID: self.article.articleID)
    }
    
    @IBAction func CommentBtnClick(_ sender: Any) {
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        //to do 自适应高度
    }
    
    
    var article = Article(){
        didSet{
            if article.articleImgs.count != 0{
                let imageURL = NSURL(string: (article.articleImgs[0]))
                if let data = try? Data(contentsOf: imageURL! as URL){
                    TopImageView.image = UIImage(data: data)
                }
            }
            ContentLabel.text = article.articleContent
            DateLabel.text = article.date + "/" + article.time
            if article.likeArticle == true {
                LikeBtn.setImage(#imageLiteral(resourceName: "LikedBtn"), for: .normal)
            }else{
                LikeBtn.setImage(#imageLiteral(resourceName: "LikeBtn"), for: .normal)
            }
            
            hero.id = "myArticle\(String(describing: article.articleID))"
        }
    }
    
    //点赞和取消赞的静态方法
    func netChangeLiekArticle(userID: Int, articleID: Int){
        let parameters: Parameters = [
            "userId": userID,
            "articleId": articleID
        ]
        //网络请求
        let url = MenuViewController.APIURLHead + "article/like"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            request in
            if let value = request.result.value{
                let json = JSON(value)
                let code = json[]["code"]
                if code == 200{
                    let likeStatus = json[]["likeArticle"].bool!
                    if self.article.likeArticle != likeStatus{
                        let nowArt = self.article
                        if likeStatus == true{
                            nowArt.likeNum += 1
                        }else{
                            nowArt.likeNum -= 1
                        }
                        nowArt.likeArticle = likeStatus
                        self.article = nowArt
                    }
                }
            }
        }
    }
    
}
