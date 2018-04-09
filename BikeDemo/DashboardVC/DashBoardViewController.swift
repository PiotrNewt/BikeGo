//
//  DashBoardViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/3/30.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit

class DashBoardViewController: UIViewController {
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedView: SpeedView!
    var timer = Timer()
    
    @IBOutlet weak var testLabel: UILabel!
    
    let locationManager = AMapLocationManager()
    //let location = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.distanceFilter = 1
        testLabel.text = "已经打开持续定位"
    
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(getSystemLocationInfo), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
        timer.invalidate()
    }
    
    @objc func getSystemLocationInfo() -> Void {
        let speed = Int(arc4random_uniform(50))+1
        //NSLog("当前速度：\(speed)")
        let nowspeed = speed == -1 ? 0 : speed
        guard speed != 0 else {
            return
        }
        speedView.speedValue = CGFloat(nowspeed)
        speedLabel.text = String(Int(nowspeed))
    }
}

extension DashBoardViewController: AMapLocationManagerDelegate {
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
        NSLog("speed：\(location.speed)")
        //getSystemLocationInfo(speed: location.speed)
        testLabel.text = String(location.speed)
    }
}

