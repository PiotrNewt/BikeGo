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
        //终点
        let endPin = MAPointAnnotation()
        endPin.coordinate = endPointCoordinate
        mapView.addAnnotation(endPin)
        
        //调整显示范围
        mapView.region.center = CLLocationCoordinate2D(latitude: Double((rideManager.naviRoute?.routeCenterPoint.latitude)!), longitude: Double((rideManager.naviRoute?.routeCenterPoint.longitude)!))
        let spanLatitude = Double((rideManager.naviRoute?.routeBounds.northEast.latitude)!) - Double((rideManager.naviRoute?.routeBounds.southWest.latitude)!)
        let spanLongitude = Double((rideManager.naviRoute?.routeBounds.northEast.longitude)!)-Double((rideManager.naviRoute?.routeBounds.southWest.longitude)!)
        mapView.region.span.latitudeDelta = spanLatitude + 0.01
        mapView.region.span.longitudeDelta = spanLongitude + 0.01
        
    }
    
    
    func rideManager(_ rideManager: AMapNaviRideManager, onCalculateRouteFailure error: Error) {
        NSLog("error:{\(error.localizedDescription)}")
    }
    
    //设置绘制折线的样式
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isKind(of: MAPolyline.self) {
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 6.0
            renderer.strokeColor = UIColor.blue
            
            return renderer
        }
        return nil
    }
    
    //标记终点
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        //避开定位蓝点
        if annotation.isKind(of: MAUserLocation.self){
            return nil
        }
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "endPointReuseIndetifier"
            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView!.canShowCallout = false
            annotationView!.isDraggable = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
            
            annotationView!.image = #imageLiteral(resourceName: "EndPin")
            //设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView!.centerOffset = CGPoint(x:1.2, y:-26);
            
            return annotationView!
        }
        
        return nil
    }
}
