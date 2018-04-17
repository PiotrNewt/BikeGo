//
//  RideDataCell.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/17.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit

class RideDataCell: UITableViewCell {
    
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var SpeedLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
