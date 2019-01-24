//
//  ViewController.swift
//  SensorTest
//
//  Created by 杨键 on 2018/4/29.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    //信息记录
    var data: [CMDeviceMotion] = [CMDeviceMotion]()
    
    let motionManager = CMMotionManager()
    
    
    @IBOutlet weak var StartBtn: UIButton!
    @IBOutlet weak var EndBtn: UIButton!
    @IBOutlet weak var TipLabel: UILabel!
    
    
    @IBAction func StartBtnClick(_ sender: Any) {
        
        startRecodingData()
        
        self.StartBtn.isEnabled = false
        self.EndBtn.isEnabled = true
    }
    
    @IBAction func EndBtnClick(_ sender: Any) {
        motionManager.stopDeviceMotionUpdates()
        self.StartBtn.isEnabled = true
        self.EndBtn.isEnabled = false
        TipLabel.text = "测试结束"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //跳转
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dataVC = segue.destination as! DataViewController
        dataVC.data = data
        dataVC.dataTitle = segue.identifier!
    }
    
    
    func startRecodingData() {
        TipLabel.text = "测试开始"
        
        if motionManager.isAccelerometerAvailable,
            motionManager.isGyroAvailable{
            // 清空一下数据
            data.removeAll()
            self.motionManager.deviceMotionUpdateInterval = 1 / 60
            let queue = OperationQueue.current
            self.motionManager.startDeviceMotionUpdates(to: queue!, withHandler:{
                (MotionData,error)  in
                
                //NSLog(String(format: "%.1f", (MotionData?.userAcceleration.x)!))
                self.data.append(MotionData!)
                
                
            })
            // self.motionManager.startDeviceMotionUpdates()
        }else{
            NSLog("设备加速计或者陀螺仪不能使用")
            TipLabel.text = "设备加速计或者陀螺仪不能使用"
        }
    }


}

