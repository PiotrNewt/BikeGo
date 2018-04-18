//
//  RideDataListViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/18.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension RideDataListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RideDataItem", for: indexPath) as! RideDataCell
        cell.rideRecord = rideRecords[indexPath.row]
        return cell
    }
    
    
}
