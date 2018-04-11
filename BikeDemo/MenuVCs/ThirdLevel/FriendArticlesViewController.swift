//
//  FriendArticlesViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/10.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FriendArticlesViewController: UIViewController {
    
    var articles: [(Article,CGFloat)] = [(Article,CGFloat)]()
    
    @IBOutlet weak var ArticlesTableView: UITableView!
    
    @IBAction func BackBtnClick(_ sender: Any) {
        hero.dismissViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        
        ArticlesTableView.delegate = self
        ArticlesTableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        netGetArticleWithFresh()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendShowArticleDetail",
            let currentCell = sender as? ArticleDetialCell,
            let currentCellIndex = ArticlesTableView.indexPath(for: currentCell),
            let articleDVC = segue.destination as? ArticleDetailViewController{
            //动画基本值
            //articleDVC.view.hero.id = currentCell.hero.id
            //传整个articel
            articleDVC.article = self.articles[currentCellIndex.row].0
        }
    }
    
    func netGetArticleWithFresh(){
        let defaults = UserDefaults.standard
        let UserID = String(describing: defaults.value(forKey: "UserID")!)
        
        let parameters: Parameters = [
            "userId": UserID
        ]
        //清空
        self.articles.removeAll()
        //网络请求
        let url = MenuViewController.APIURLHead + "article/fresh"
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
                        if let data = try? Data(contentsOf: imageURL! as URL){
                            user.userImg = data as NSData
                        }
                        
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
                        
                        self.articles.append((article,0.0))
                    }
                    self.ArticlesTableView.reloadData()
                }
            }
        }
    }

}

extension FriendArticlesViewController: UITableViewDelegate, UITableViewDataSource, ArticleDetialCellDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "FriendArticleDetialItem", for: indexPath) as! ArticleDetialCell)
        cell.article = self.articles[indexPath.row].0
        cell.delegate = self
        self.articles[indexPath.row].1 = cell.cellHeight
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.articles[indexPath.row].1
    }

    func willComment(sender: Any) {
        //to do 跳转到评论列表吧 应该
    }
    
}
