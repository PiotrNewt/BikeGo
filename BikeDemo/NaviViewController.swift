//
//  NaviViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/3/19.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import Hero

class NaviViewController: UIViewController, MAMapViewDelegate, AMapLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Http
        AMapServices.shared().enableHTTPS = true
        
        //地图
        let mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.isZoomEnabled = true
        mapView.isRotateEnabled = true
        mapView.showsCompass = false
        mapView.zoomLevel = 17
        self.view.addSubview(mapView)
        
        //定位蓝点
        let r = MAUserLocationRepresentation()
        r.showsAccuracyRing = true
        mapView.update(r)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
