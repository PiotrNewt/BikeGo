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

    let mapView = MAMapView(frame: UIScreen.main.bounds)
    let search = AMapSearchAPI()
    let pointAnnotation = MAPointAnnotation()
    let r = MAUserLocationRepresentation()
    var ifTouchInfoViewLoaded = false
    var reAddress = ""
    
    @IBOutlet weak var TouchInfoView: UIView!
    @IBOutlet weak var TouchName: UILabel!
    @IBOutlet weak var TouchRoadPlanBtn: UIButton!
    @IBOutlet weak var TouchAddress: UILabel!
    
    @IBOutlet weak var MapModeBtn: UIButton!
    @IBOutlet weak var TrafficBtn: UIButton!
    @IBOutlet weak var MyLocationBtn: UIButton!
    
    
    @IBAction func changeTrafficInfo(_ sender: Any) {
        guard mapView.isShowTraffic == true else {
            mapView.isShowTraffic = true
            TrafficBtn.setBackgroundImage(#imageLiteral(resourceName: "TrafficOn"), for: UIControlState.normal)
            return
        }
        guard mapView.isShowTraffic == false else {
            mapView.isShowTraffic = false
            TrafficBtn.setBackgroundImage(#imageLiteral(resourceName: "TrafficOff"), for: UIControlState.normal)
            return
        }
    }
    
    @IBAction func setMapCenterINMyLocation(_ sender: Any) {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        mapView.zoomLevel = 17
        TouchInfoView.isHidden = true
    }
    
    
    /*
    @IBAction func StartRoadPlan(_ sender: Any) {
        let RoadPlanVC = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoadPlanSelect") as? RoadPlanViewController)!
        RoadPlanVC.endPointCoordinate = pointAnnotation.coordinate
        RoadPlanVC.startPoi = GetUserLocation()
        RoadPlanVC.hero.modalAnimationType = HeroDefaultAnimationType.zoom
        hero.replaceViewController(with: RoadPlanVC)
    }
    */
    
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
        mapView.zoomLevel = 17
        mapView.touchPOIEnabled = true
        self.view.addSubview(mapView)
        
        //添加按钮
        mapView.addSubview(MapModeBtn)
        mapView.isShowTraffic = true
        TrafficBtn.setBackgroundImage(#imageLiteral(resourceName: "TrafficOn"), for: UIControlState.normal)
        mapView.addSubview(TrafficBtn)
        
        mapView.addSubview(MyLocationBtn)
        
        //mapView.userLocation.location.speed
        
        //定位蓝点
        r.showsHeadingIndicator = true
        r.showsAccuracyRing = true
        mapView.update(self.r)
        
        //搜索
        search?.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let RoadPlanVC = segue.destination as? RoadPlanViewController{
        RoadPlanVC.endPointCoordinate = pointAnnotation.coordinate
        RoadPlanVC.startPoi = GetUserLocation()
        }
    }
    
    func LoadTouchInfoView(touchPoi: MATouchPoi) -> UIView {
        TouchName.text = touchPoi.name
        TouchInfoView.addSubview(TouchName)
        TouchInfoView.addSubview(TouchAddress)
        TouchInfoView.addSubview(TouchRoadPlanBtn)
        ifTouchInfoViewLoaded = true
        TouchInfoView.isHidden = false
        
        return TouchInfoView
    }
    
    func RefreshTouchInfoView(touchPoi: MATouchPoi) -> Void {
        TouchName.text = touchPoi.name
        TouchInfoView.isHidden = false
    }
    
    func HiddenTouchInfoView() -> Void {
        TouchInfoView.isHidden = true
    }
    
    func ReverseGeoCoding(coordinate: CLLocationCoordinate2D) -> Void {
        
        let request = AMapReGeocodeSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        request.requireExtension = true

        search?.aMapReGoecodeSearch(request)
    }
    
    func GetUserLocation() -> AMapNaviPoint{
        //位置信息
        return (AMapNaviPoint.location(withLatitude: CGFloat(mapView.userLocation.location.coordinate.latitude), longitude: CGFloat(mapView.userLocation.location.coordinate.longitude)))
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
    
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        if response.regeocode == nil {
            return
        }
        //解析逆地理返回值
        if response.regeocode != nil {
            TouchAddress.text = response.regeocode.formattedAddress
            reAddress = response.regeocode.formattedAddress
        }
    }
    
    func mapView(_ mapView: MAMapView!, didTouchPois pois: [Any]!) {
        //显示标记
        let touchPoi = pois[0] as! MATouchPoi
        
        //逆地理编码
        ReverseGeoCoding(coordinate: touchPoi.coordinate)
        
        pointAnnotation.coordinate = touchPoi.coordinate
        pointAnnotation.title = touchPoi.name
        mapView.addAnnotation(pointAnnotation)
        mapView.setCenter(touchPoi.coordinate, animated: true)
        
        if ifTouchInfoViewLoaded == false {
            self.view.addSubview(LoadTouchInfoView(touchPoi: touchPoi))
        }else{
            RefreshTouchInfoView(touchPoi: touchPoi)
        }
        
    }
    
    //标记方法
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        //避开定位蓝点
        if annotation.isKind(of: MAUserLocation.self){
            return nil
        }
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView!.canShowCallout = false
            annotationView!.isDraggable = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
            
            annotationView!.image = #imageLiteral(resourceName: "BluePin")
            //设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView!.centerOffset = CGPoint(x:1.2, y:-26);
            
            return annotationView!
        }
        
        return nil
    }
}


