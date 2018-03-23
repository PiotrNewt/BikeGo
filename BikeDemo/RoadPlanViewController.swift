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
    var endPointCoordinate = CLLocationCoordinate2D(latitude: 111, longitude: 122)
    var startPoi = AMapNaviPoint()
    //地图
    let mapView = MAMapView(frame: UIScreen.main.bounds)
    
    let rideManager = AMapNaviRideManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Http
        AMapServices.shared().enableHTTPS = true
        
        //地图
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.isZoomEnabled = true
        mapView.isRotateEnabled = true
        mapView.showsCompass = false
        mapView.zoomLevel = 15
        mapView.touchPOIEnabled = true
        self.view.addSubview(mapView)
        
        //路线规划
        rideManager.delegate = self
        let endPoi = AMapNaviPoint.location(withLatitude: CGFloat(endPointCoordinate.latitude), longitude: CGFloat(endPointCoordinate.longitude))
        if endPoi != nil {rideManager.calculateRideRoute(withStart: startPoi, end: endPoi!)}
        
        print(rideManager.calculateRideRoute(withStart: startPoi, end: endPoi!))

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
    
    func rideManager(onCalculateRouteSuccess rideManager: AMapNaviRideManager) {
        NSLog("CalculateRouteSuccess")
        //绘制路线
        let roadArray = rideManager.naviRoute?.routeCoordinates
        var lineCoordinates: [CLLocationCoordinate2D] = []
        if roadArray != nil{
            for index in roadArray!{
                lineCoordinates.append(CLLocationCoordinate2D(latitude: CLLocationDegrees(index.latitude), longitude: CLLocationDegrees(index.longitude)))
            }
        }

        let polyline: MAPolyline = MAPolyline(coordinates: &lineCoordinates, count: UInt(lineCoordinates.count))
         mapView.add(polyline)
    }
    
    
    func rideManager(_ rideManager: AMapNaviRideManager, onCalculateRouteFailure error: Error) {
        NSLog("error:{\(error.localizedDescription)}")
    }
    
    //设置绘制折线的样式
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isKind(of: MAPolyline.self) {
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 8.0
            renderer.strokeColor = UIColor.cyan
            
            return renderer
        }
        return nil
    }
}
