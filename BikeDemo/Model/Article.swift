//
//  Article.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/8.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import Foundation

public class Article {
    
    var articleID: Int = 0
    var user = User()
    var articleContent: String = ""
    var articleImgs: [String] = []
    var likeNum: Int = 0
    var commentNum: Int = 0
    var date: String = ""
    var time: String = ""
    var likeArticle: Bool = false
    
}
