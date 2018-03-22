//
//  RoadPlanViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/3/22.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit

class RoadPlanViewController: UIViewController {
    
    //导航终点
    var endPoint = CLLocationCoordinate2D(latitude: 111, longitude: 122)
    
    let rideManager = AMapNaviRideManager()
    
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
        mapView.zoomLevel = 15
        mapView.touchPOIEnabled = true
        self.view.addSubview(mapView)
        
        rideManager.delegate = self
        //rideManager.calculateRideRoute(withStart: <#T##AMapNaviPoint#>, end: <#T##AMapNaviPoint#>)

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

extension RoadPlanViewController: AMapNaviRideManagerDelegate, MAMapViewDelegate{
    
    
}
