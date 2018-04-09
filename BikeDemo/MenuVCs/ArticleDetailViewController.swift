//
//  ArticleDetailViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/9.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ArticleDetailViewController: UIViewController {
    
    var article: Article!{
        didSet{
            netGetComment()
            TableView.reloadData()
        }
    }
    
    var commentes: [Comment] = [Comment]() {
        didSet{TableView.reloadData()}
    }
    
    var cellHeight: CGFloat = 0.0
    var commentCellHeigt: CGFloat = 0.0
    
    @IBOutlet weak var TableView: UITableView!
    
    
    @IBAction func BackBtnClick(_ sender: Any) {
        hero.dismissViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        
        TableView.delegate = self
        TableView.dataSource = self
        TableView.allowsSelection = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func netGetComment() {
        
        let parameters: Parameters = [
            "articleId": article.articleID
        ]
        
        //网络请求
        let url = MenuViewController.APIURLHead + "article/getComments"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            request in
            if let value = request.result.value{
                let json = JSON(value)
                let code = json[]["code"]
                if code == 200{
                    for (_, commentJson): (String, JSON) in json[]["comments"] {
                        let newComment = Comment()
                        newComment.comContent = commentJson[]["content"].string!
                        newComment.comUserName = commentJson[]["user"]["userName"].string!
                        newComment.comUserImage = commentJson[]["user"]["userImg"].string!
                        self.commentes.append(newComment)
                    }
                }else{
                    //to do: 错误处理
                }
            }
        }
    }

}

extension ArticleDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentes.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var Rcell = UITableViewCell()
        if indexPath.row == 0{
            let cell = (tableView.dequeueReusableCell(withIdentifier: "articleDetialItem", for: indexPath) as! ArticleDetialCell)
            cell.article = self.article
            cellHeight = cell.cellHeight
            Rcell = cell
        }else{
            let cell = (tableView.dequeueReusableCell(withIdentifier: "CommentItem", for: indexPath) as! CommentCell)
            cell.localComment = commentes[indexPath.row - 1]
            commentCellHeigt = cell.ComContentLabel.frame.height + cell.CommentImgView.frame.height
            Rcell = cell
        }
        return Rcell
    }
    
    //cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0.0
        if indexPath.row == 0{
            height = cellHeight
        }else{
            height = commentCellHeigt
        }
        return height
    }
}
