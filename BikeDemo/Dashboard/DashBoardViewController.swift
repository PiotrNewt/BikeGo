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
    
    
    let location = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //speedView.speedValue = CGFloat(12)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getSystemLocationInfo), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    @objc func getSystemLocationInfo() -> Void {
        var speed = location.speed
        print("当前速度：\(0)")
        speed = speed == -1 ? 0 : speed
        guard speed != 0 else {
            return
        }
        speedView.speedValue = CGFloat(location.speed)
        speedLabel.text = String(Int(speed))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
