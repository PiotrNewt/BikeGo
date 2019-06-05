//
//  RideDataCell.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/17.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit

class RideDataCell: UITableViewCell {
    
    var rideRecord = RideRecord(){
        didSet{
            dataLoad()
        }
    }
    
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
    
    func dataLoad() {
        // 日期
        if let dateData = rideRecord.recordPoints[0].times{
            let dformatter = DateFormatter()
            dformatter.dateFormat = "MM月dd日 E"
            self.DateLabel.text = "\(dformatter.string(from: dateData))"
        }
        // 时间
        if let startDate = rideRecord.recordPoints[0].times,
            let endDate = rideRecord.recordPoints[rideRecord.recordPoints.endIndex - 1].times{
                let timeNumber = Int(endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970)
            self.TimeLabel.text = RideDataCell.getHHMMSSFormSS(seconds: timeNumber)
        }
        // 平均时速
        var speed = 0.0
        for index in 0..<rideRecord.recordPoints.count{
            speed += rideRecord.recordPoints[index].speed
        }
        speed /= Double(rideRecord.recordPoints.count)
        self.SpeedLabel.text = String(format: "%.1f", speed)
    }
    
    static func getHHMMSSFormSS(seconds:Int) -> String {
        //let str_hour = NSString(format: "%02ld", seconds / 3600)
        let str_minute = NSString(format: "%02ld", (seconds % 3600) / 60)
        let str_second = NSString(format: "%02ld", seconds % 60)
        //let format_time = NSString(format: "%@:%@:%@", str_hour,str_minute, str_second)
        let format_time = NSString(format: "%@:%@", str_minute, str_second)

        return format_time as String
    }

}
