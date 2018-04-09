//
//  CommentCell.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/9.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var CommentImgView: UIImageView!
    @IBOutlet weak var ComUserNameLabel: UILabel!
    @IBOutlet weak var ComContentLabel: UILabel!
    
    var localComment = Comment(){
        didSet{
            let imageUrl = NSURL(string: "http://120.77.87.78:8080/cycle/image/" + localComment.comUserImage)
            if let data = try? Data(contentsOf: imageUrl! as URL){
                CommentImgView.image = UIImage(data: data)
            }
            ComUserNameLabel.text = localComment.comUserName
            ComContentLabel.text = localComment.comContent
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
