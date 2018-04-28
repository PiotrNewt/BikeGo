//
//  DataGraphViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/18.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import ScrollableGraphView

enum DateType {
    case speedDate
    case altitudeDate
}

class DataGraphViewController: UIViewController {
    
    var rideRecord = RideRecord()
    var dataType: DateType = .altitudeDate
    
    @IBOutlet weak var DataView: UIView!
    
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    
    @IBOutlet weak var AltitudeLabel: UILabel!
    @IBOutlet weak var UseTimeLabel: UILabel!
    @IBOutlet weak var MaxSpeedLabel: UILabel!
    
    @IBOutlet weak var LineC: UIView!
    @IBOutlet weak var LineL: UIView!
    @IBOutlet weak var LineR: UIView!
    
    
    @IBAction func BlackBtnClick(_ sender: Any) {
        hero.dismissViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        
        self.view.addSubview(DataView)
        analyzeData()
        loadGraphView_speed()
        
        //添加视图重新加载的手势
        let moreTap = UITapGestureRecognizer.init(target:self, action: #selector(handleMoreTap(tap:)))
        moreTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(moreTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //遍历数组计算数据
    func analyzeData(){
        //时间
        if let timedata = rideRecord.recordPoints[0].times{
            let dformatter = DateFormatter()
            dformatter.dateFormat = "yy-MM-dd"
            DateLabel.text = "\(dformatter.string(from: timedata))"
        }
        
        if let timedata = rideRecord.recordPoints[0].times{
            let dformatter = DateFormatter()
            dformatter.dateFormat = "HH:mm:ss"
            TimeLabel.text = "time:\(dformatter.string(from: timedata))"
        }
        
        //时间差
        if let startDate = rideRecord.recordPoints[0].times,
            let endDate = rideRecord.recordPoints[rideRecord.recordPoints.endIndex - 1].times{
            let timeNumber = Int(endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970)
            self.UseTimeLabel.text = RideDataCell.getHHMMSSFormSS(seconds: timeNumber)
        }else{
            self.UseTimeLabel.text = "00:00"
        }
        //遍历计算海拔差 和 极速
        var maxSpeed = 0.0
        var minAltitude = rideRecord.recordPoints[0].altitude
        var maxAltitude = 0.0
        for poi in rideRecord.recordPoints{
            if poi.speed > maxSpeed{
                maxSpeed = poi.speed
            }
            if poi.altitude > maxAltitude{
                maxAltitude = poi.altitude
            }
            if poi.altitude < minAltitude{
                minAltitude = poi.altitude
            }
        }
        MaxSpeedLabel.text = String(format: "%.1f", maxSpeed)
        AltitudeLabel.text = String(format: "%.1f", maxAltitude - minAltitude)
    }
    
    func loadGraphView_speed(){
        
        let speedGraphView = ScrollableGraphView()
        speedGraphView.backgroundFillColor = UIColor.clear
        speedGraphView.topMargin = 10
        speedGraphView.tag = 11
        speedGraphView.dataSource = self
        
        let speedLinePlot = LinePlot(identifier: "speed")
        speedLinePlot.lineWidth = 2
        speedLinePlot.lineColor = UIColor.colorFromHex(hexString: "#5B3BD9") //5B3BD9 //#4C31B6
        speedLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        speedLinePlot.shouldFill = true
        speedLinePlot.fillType = ScrollableGraphViewFillType.gradient
        speedLinePlot.fillGradientStartColor = UIColor.colorFromHex(hexString: "#4C31B6").withAlphaComponent(0.8)
        speedLinePlot.fillGradientEndColor = UIColor.colorFromHex(hexString: "#8C37EE").withAlphaComponent(0.02) //#8C37EE
        
        speedLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 11)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.9)
        
        speedGraphView.addReferenceLines(referenceLines: referenceLines)
        speedGraphView.addPlot(plot: speedLinePlot)
        
        speedGraphView.shouldAdaptRange = true
        speedGraphView.shouldAnimateOnAdapt = true
        
        speedGraphView.frame = CGRect(x: 0, y: 155, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 155 - 174)
        self.view.addSubview(speedGraphView)
        
        //线条颜色
        UIView.animate(withDuration: 1.5, delay: 0.1, options: .curveLinear, animations: {() -> Void in
            self.LineC.backgroundColor = UIColor.colorFromHex(hexString: "#864FF4")
            self.LineL.backgroundColor = UIColor.colorFromHex(hexString: "#864FF4")
            self.LineR.backgroundColor = UIColor.colorFromHex(hexString: "#864FF4")
        }, completion: nil)
  
        
        // 移除原来的view
        if let oldView = view.viewWithTag(22){
            oldView.removeFromSuperview()
        }
        
    }
    
    func loadGraphView_altitude(){
        
        let altitudeGraphView = ScrollableGraphView()
        altitudeGraphView.backgroundFillColor = UIColor.clear
        altitudeGraphView.topMargin = 10
        altitudeGraphView.tag = 22
        altitudeGraphView.dataSource = self
        
        let altitudeLinePlot = LinePlot(identifier: "altitude")
        altitudeLinePlot.lineWidth = 2
        altitudeLinePlot.lineColor = UIColor.colorFromHex(hexString: "#FF913F")
        altitudeLinePlot.lineStyle = ScrollableGraphViewLineStyle.straight
        
        altitudeLinePlot.shouldFill = true
        altitudeLinePlot.fillType = ScrollableGraphViewFillType.gradient
        altitudeLinePlot.fillGradientStartColor = UIColor.colorFromHex(hexString: "#F89E4C").withAlphaComponent(0.5)
        altitudeLinePlot.fillGradientEndColor = UIColor.colorFromHex(hexString: "#EEAF37").withAlphaComponent(0.02)
        
        altitudeLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 11)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.9)
        
        altitudeGraphView.addReferenceLines(referenceLines: referenceLines)
        altitudeGraphView.addPlot(plot: altitudeLinePlot)
        
        altitudeGraphView.shouldAdaptRange = true
        altitudeGraphView.shouldAnimateOnAdapt = true
        
        altitudeGraphView.frame = CGRect(x: 0, y: 155, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 155 - 174)
        self.view.addSubview(altitudeGraphView)
        
        UIView.animate(withDuration: 1.5, delay: 0.1, options: .curveLinear, animations: {() -> Void in
            self.LineC.backgroundColor = UIColor.colorFromHex(hexString: "#F2884E")
            self.LineL.backgroundColor = UIColor.colorFromHex(hexString: "#F2884E")
            self.LineR.backgroundColor = UIColor.colorFromHex(hexString: "#F2884E")
        }, completion: nil)
        
        // 移除原来的view
        if let oldView = view.viewWithTag(11){
            oldView.removeFromSuperview()
        }
    }
    
    //双击方法
    @objc func handleMoreTap(tap:UITapGestureRecognizer) {
        guard dataType != .speedDate else{
            loadGraphView_speed()
            dataType = .altitudeDate
            return
        }
        guard dataType != .altitudeDate  else {
            loadGraphView_altitude()
            dataType = .speedDate
            return
        }
    }

}

extension DataGraphViewController: ScrollableGraphViewDataSource{
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        switch(plot.identifier) {
        case "speed":
            return rideRecord.recordPoints[pointIndex].speed
        case "altitude":
            return rideRecord.recordPoints[pointIndex].altitude
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return " " //"Data\(pointIndex)"
    }
    
    func numberOfPoints() -> Int {
        return rideRecord.recordPoints.count
    }
    
    
}
