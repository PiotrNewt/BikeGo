//
//  NaviViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/3/19.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import Hero

class NaviViewController: UIViewController, AMapLocationManagerDelegate{

    let search = AMapSearchAPI()
    let pointAnnotation = MAPointAnnotation()
    
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
        mapView.touchPOIEnabled = true
        self.view.addSubview(mapView)
        
        //定位蓝点
        let r = MAUserLocationRepresentation()
        //朝向
        r.showsHeadingIndicator = true
        r.showsAccuracyRing = true
        mapView.update(r)
        
        
        //搜索
/*
        search?.delegate = self
        let request = AMapPOIKeywordsSearchRequest()
        request.keywords = "肯德基"
        request.requireExtension = true
        
        request.requireSubPOIs = true
*/
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


extension NaviViewController:AMapSearchDelegate, MAMapViewDelegate {
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        if response.count == 0 {
            return
        }
        //解析搜索返回值
    }
    
    func mapView(_ mapView: MAMapView!, didTouchPois pois: [Any]!) {
        //显示标记
        
        let touchPoi = pois[0] as! MATouchPoi
        print(touchPoi.name)
        print(touchPoi.coordinate)
        print(touchPoi.uid)
        
        
        pointAnnotation.coordinate = touchPoi.coordinate
        pointAnnotation.title = touchPoi.name
        mapView.addAnnotation(pointAnnotation)
        mapView.setCenter(touchPoi.coordinate, animated: true)
        
        }
    
    //标记方法
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView!.canShowCallout = true
            annotationView!.isDraggable = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
            
            annotationView!.image = #imageLiteral(resourceName: "BluePin")
            //设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView!.centerOffset = CGPoint(x:2.5, y:-24);
            
            return annotationView!
        }
        
        return nil
    }
}


