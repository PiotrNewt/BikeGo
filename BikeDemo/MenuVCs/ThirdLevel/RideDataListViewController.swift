//
//  RideDataListViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/18.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import RealmSwift

class RideDataListViewController: UIViewController {
    
    var rideRecords: [RideRecord] = [RideRecord]()

    @IBOutlet weak var ListTableView: UITableView!
    
    @IBAction func BackBtnClick(_ sender: Any) {
        hero.dismissViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true

        ListTableView.delegate = self
        ListTableView.dataSource = self
        loadDataFromRealmDB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //加载数据
    func loadDataFromRealmDB() {
        
        rideRecords.removeAll()
        
        let defaults = UserDefaults.standard
        let UserID = String(describing: defaults.value(forKey: "UserID")!)
        let realm = try! Realm()
        let rideRecords_DB = realm.objects(RideRecord.self).filter("userID = \(UserID)")
        for RR in rideRecords_DB{
            self.rideRecords.append(RR)
        }
        self.ListTableView.reloadData()
    }

}

extension RideDataListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return rideRecords.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RideDataItem", for: indexPath) as! RideDataCell
        cell.rideRecord = rideRecords[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataGraphVC = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DataGraph") as? DataGraphViewController)!
        dataGraphVC.rideRecord = self.rideRecords[indexPath.row]
        self.show(dataGraphVC, sender: nil)
    }
    
    
}
