//
//  DataViewController.swift
//  SensorTest
//
//  Created by 杨键 on 2018/4/29.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import CoreMotion

class DataViewController: UIViewController {
    
    //数据组
    var data: [CMDeviceMotion] = [CMDeviceMotion]()
    
    //显示数据
    var dataText: String = ""
    
    //数据标题
    var dataTitle: String = ""
    
    @IBOutlet weak var DataTableView: UITableView!
    @IBOutlet weak var TitleLabel: UILabel!
    

    @IBAction func BackBtnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.DataTableView.delegate = self
        self.DataTableView.dataSource = self
        TitleLabel.text = dataTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //跳转
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let textVC = segue.destination as! TextViewController
        textVC.dataText = dataText
        textVC.dataTitle = TitleLabel.text! + "_" + "\(data.count)"
    }
    
}

extension DataViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataItem", for: indexPath)
        var nowdata = ""
        switch TitleLabel.text! {
        case "acceleration.x":
            nowdata = String(format: "%.6f", data[indexPath.row].userAcceleration.x)
        case "acceleration.y":
            nowdata = String(format: "%.6f", data[indexPath.row].userAcceleration.y)
        case "acceleration.z":
            nowdata = String(format: "%.6f", data[indexPath.row].userAcceleration.z)
        case "rotationRate.x":
            nowdata = String(format: "%.6f", data[indexPath.row].rotationRate.x)
        case "rotationRate.y":
            nowdata = String(format: "%.6f", data[indexPath.row].rotationRate.y)
        case "rotationRate.z":
            nowdata = String(format: "%.6f", data[indexPath.row].rotationRate.z)
        case "attitude.yaw":
            nowdata = String(format: "%.6f", data[indexPath.row].attitude.yaw)
        case "attitude.pitch":
            nowdata = String(format: "%.6f", data[indexPath.row].attitude.pitch)
        case "attitude.roll":
            nowdata = String(format: "%.6f", data[indexPath.row].attitude.roll)
        default:
            return cell
        }
        cell.textLabel?.text = nowdata
        dataText = dataText + nowdata  + "/"
        return cell
    }
    
}
