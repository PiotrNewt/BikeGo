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
    var dataType: DateType = .speedDate
    
    @IBAction func ReloadBtnClick(_ sender: Any) {
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
    @IBAction func BlackBtnClick(_ sender: Any) {
        hero.dismissViewController()
    }
    
    var numberOfItems = 27
    var plotOneData: [Double] = [3,45,64,75,3,23,232,5,5,75,6,75,8,9,89,7,0,3,87,32,4,54,56,7,56,7,86]
    var plotTwoData: [Double] = [7,0,3,87,32,4,54,56,7,56,86,6,75,8,9,89,7,3,45,64,75,3,23,23,5,5,75,34]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        
        loadGraphView_speed()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadGraphView_speed(){
        
        let speedGraphView = ScrollableGraphView()
        speedGraphView.tag = 11
        speedGraphView.dataSource = self
        
        let speedLinePlot = LinePlot(identifier: "speed")
        speedLinePlot.lineWidth = 5
        speedLinePlot.lineColor = UIColor.colorFromHex(hexString: "#D34CA3")
        speedLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        speedLinePlot.shouldFill = true
        speedLinePlot.fillType = ScrollableGraphViewFillType.solid
        speedLinePlot.fillColor = UIColor.colorFromHex(hexString: "#D34CA3").withAlphaComponent(0.5)
        
        speedLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.black.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.black
        
        referenceLines.dataPointLabelColor = UIColor.black.withAlphaComponent(1)
        
        speedGraphView.addReferenceLines(referenceLines: referenceLines)
        speedGraphView.addPlot(plot: speedLinePlot)
        
        speedGraphView.shouldAdaptRange = true
        speedGraphView.shouldAnimateOnAdapt = true
        
        let frame = CGRect(x: 8, y: 50, width: UIScreen.main.bounds.width - 16, height: UIScreen.main.bounds.height * 2 / 3 - 100)
        speedGraphView.frame = frame
        self.view.addSubview(speedGraphView)
        
        // 移除原来的view
        if let oldView = view.viewWithTag(22){
            oldView.removeFromSuperview()
        }
        
    }
    
    func loadGraphView_altitude(){
        
        let altitudeGraphView = ScrollableGraphView()
        altitudeGraphView.tag = 22
        altitudeGraphView.dataSource = self
        
        let altitudeLinePlot = LinePlot(identifier: "altitude")
        altitudeLinePlot.lineWidth = 5
        altitudeLinePlot.lineColor = UIColor.colorFromHex(hexString: "#F7B851")
        altitudeLinePlot.lineStyle = ScrollableGraphViewLineStyle.straight
        
        altitudeLinePlot.shouldFill = true
        altitudeLinePlot.fillType = ScrollableGraphViewFillType.solid
        altitudeLinePlot.fillColor = UIColor.colorFromHex(hexString: "#F7B851").withAlphaComponent(0.5)
        
        altitudeLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.easeOut
        
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.black.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.black
        
        referenceLines.dataPointLabelColor = UIColor.black.withAlphaComponent(1)
        
        altitudeGraphView.addReferenceLines(referenceLines: referenceLines)
        altitudeGraphView.addPlot(plot: altitudeLinePlot)
        
        altitudeGraphView.shouldAdaptRange = true
        altitudeGraphView.shouldAnimateOnAdapt = true
        
        let frame = CGRect(x: 8, y: 50, width: UIScreen.main.bounds.width - 16, height: UIScreen.main.bounds.height * 2 / 3 - 100)
        altitudeGraphView.frame = frame
        self.view.addSubview(altitudeGraphView)
        
        // 移除原来的view
        if let oldView = view.viewWithTag(11){
            oldView.removeFromSuperview()
        }
    }

}

extension DataGraphViewController: ScrollableGraphViewDataSource{
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        switch(plot.identifier) {
        case "speed":
            return plotOneData[pointIndex]
        case "altitude":
            return plotTwoData[pointIndex]
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "下标 \(pointIndex)"
    }
    
    func numberOfPoints() -> Int {
        return numberOfItems
    }
    
    
}
