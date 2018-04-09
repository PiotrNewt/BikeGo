//
//  ArticleDetialCell.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/9.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ArticleDetialCell: UITableViewCell {

    @IBOutlet weak var UserImgView: UIImageView!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var ContentLabel: UILabel!
    @IBOutlet weak var IamgeCollView: UICollectionView!
    @IBOutlet weak var LikeBtn: UIButton!
    @IBOutlet weak var CommentBtn: UIButton!
    @IBOutlet weak var LikeNumLabel: UILabel!
    @IBOutlet weak var CommentNumLabel: UILabel!
    
    @IBAction func likedBtnClick(_ sender: Any) {
    }
    
    @IBAction func CommentBtnClick(_ sender: Any) {
    }
    
    
    var images: [UIImage] = []
    var cellHeight: CGFloat = 0.0
    
    var article = Article(){
        didSet{
            UserImgView.image = UIImage(data: article.user.userImg as Data)
            UserNameLabel.text = article.user.userName
            DateLabel.text = article.date + "/" + article.time
            ContentLabel.text = article.articleContent
            LikeNumLabel.text = "\(article.likeNum)"
            CommentNumLabel.text = "\(article.commentNum)"
            if article.likeArticle == true
            {
                LikeBtn.setImage(#imageLiteral(resourceName: "LikedBtn"), for: .normal)
            }
            if images.count == 0{
                IamgeCollView.isHidden = true
            }else{
                IamgeCollView.isHidden = false
                transfImages()
            }
            layoutBtn()
        }
    }
    
    func layoutBtn() {
        if images.count == 0{
            LikeBtn.frame.origin.y = ContentLabel.frame.origin.y + ContentLabel.frame.height
            CommentBtn.frame.origin.y = LikeBtn.frame.origin.y
            LikeNumLabel.frame.origin.y = LikeBtn.frame.origin.y
            CommentNumLabel.frame.origin.y = LikeBtn.frame.origin.y
            cellHeight = UserImgView.frame.height * 2 + ContentLabel.frame.height + LikeBtn.frame.height
        }else{
            LikeBtn.frame.origin.y = IamgeCollView.frame.origin.y + IamgeCollView.frame.height
            CommentBtn.frame.origin.y = LikeBtn.frame.origin.y
            LikeNumLabel.frame.origin.y = LikeBtn.frame.origin.y
            CommentNumLabel.frame.origin.y = LikeBtn.frame.origin.y
            cellHeight = IamgeCollView.frame.height + ContentLabel.frame.height + UserImgView.frame.height * 2 + LikeBtn.frame.height
        }
    }
    
    func transfImages() {
        if article.articleImgs.count == 0{return}
        for imageUrlString in article.articleImgs {
            let imageUrl = NSURL(string: imageUrlString)
            if let data = try? Data(contentsOf: imageUrl! as URL){
                images.append(UIImage(data: data as Data)!)
            }
            IamgeCollView.reloadData()
        }
    }
    
    static func netChangeLiekArticle(userID: Int, articleID: Int) {
        let parameters: Parameters = [
            "userId": userID,
            "articleId": articleID
        ]
        //网络请求
        let url = MenuViewController.APIURLHead + "article/getComments"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            request in
            if let value = request.result.value{
                let json = JSON(value)
                let code = json[]["code"]
                if code == 200{
                    /////////////////////////////////////////////////////
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.IamgeCollView.delegate = self
        self.IamgeCollView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ArticleDetialCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollImagItem", for: indexPath)
        return cell
    }
    
    
}
