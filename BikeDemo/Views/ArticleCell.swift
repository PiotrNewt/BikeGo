//
//  ArticleCell.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/7.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit

class ArticleCell: UICollectionViewCell {
    
    
    @IBOutlet weak var TopImageView: UIImageView!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var LikeBtn: UIButton!
    @IBOutlet weak var CommentBtn: UIButton!
    @IBOutlet weak var ContentLabel: UILabel!
    
    //to do 两个按钮的跳转
    @IBAction func LikeBtnClick(_ sender: Any) {
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
            if article.likeArticle == true { LikeBtn.setImage(#imageLiteral(resourceName: "LikedBtn"), for: .normal) }
            
            hero.id = "myArticle\(String(describing: article.articleID))"
        }
    }
    
}
