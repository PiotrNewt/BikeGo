//
//  NaviViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/3/19.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit
import Hero

class NaviViewController: UIViewController {

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
    @IBOutlet weak var SearchPOIBtn: UIButton!
    @IBOutlet weak var MapCommonStyleBtn: UIButton!
    @IBOutlet weak var MapSateStyleBtn: UIButton!
    @IBOutlet weak var MapNightStyleBtn: UIButton!
    
    
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
        if TouchInfoView.isHidden == false {
            MyLocationBtn.frame.origin.y = MyLocationBtn.frame.origin.y + 100
            TouchInfoView.isHidden = true
            mapView.removeAnnotation(pointAnnotation)
        }
    }
    
    @IBAction func commonBtnClick(_ sender: Any) {
        mapView.mapType = .standard
        mapModeBtnsGoback()
    }
    @IBAction func sateBtnClick(_ sender: Any) {
        mapView.mapType = .satellite
        mapModeBtnsGoback()
    }
    @IBAction func nightBtnClick(_ sender: Any) {
        mapView.mapType = .standardNight
        mapModeBtnsGoback()
    }
    @IBAction func mapModeBtnClick(_ sender: Any) {
        if MapCommonStyleBtn.frame.origin.x == MapModeBtn.frame.origin.x {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {() -> Void in
                self.MapCommonStyleBtn.frame.origin.x -= 221
                self.MapSateStyleBtn.frame.origin.x -= 157
                self.MapNightStyleBtn.frame.origin.x -= 93
            }, completion: nil)
        } else {
            mapModeBtnsGoback()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true
        
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
        
        //添加控件
        mapView.addSubview(MapCommonStyleBtn)
        mapView.addSubview(MapSateStyleBtn)
        mapView.addSubview(MapNightStyleBtn)
        mapView.addSubview(MapModeBtn)
        mapView.addSubview(SearchPOIBtn)
        
        mapView.isShowTraffic = true
        TrafficBtn.setBackgroundImage(#imageLiteral(resourceName: "TrafficOn"), for: UIControlState.normal)
        mapView.addSubview(TrafficBtn)
        
        ///位置按钮
        mapView.addSubview(MyLocationBtn)
        TouchInfoView.isHidden = true
        
        //mapView.userLocation.location.speed
        //let lo = CLLocation()
        
        //定位蓝点
        r.showsHeadingIndicator = true
        r.showsAccuracyRing = true
        mapView.update(self.r)
        
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
            RoadPlanVC.mapView.mapType = mapView.mapType
        }
        
        if let searchVC = segue.destination as? SearchViewController {
            searchVC.delegate = self
        }
    }
    
    func LoadTouchInfoView(touchPoi: MATouchPoi) -> UIView {
        TouchName.text = touchPoi.name
        TouchInfoView.addSubview(TouchName)
        TouchInfoView.addSubview(TouchAddress)
        TouchInfoView.addSubview(TouchRoadPlanBtn)
        ifTouchInfoViewLoaded = true
        TouchInfoView.isHidden = false
        //定位按钮空位
        MyLocationBtn.frame.origin.y = MyLocationBtn.frame.origin.y - 100
        
        return TouchInfoView
    }
    
    func RefreshTouchInfoView(touchPoi: MATouchPoi) -> Void {
        TouchName.text = touchPoi.name
        if TouchInfoView.isHidden == true {
            MyLocationBtn.frame.origin.y = MyLocationBtn.frame.origin.y - 100
            TouchInfoView.isHidden = false
        }
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

    func mapModeBtnsGoback() -> Void {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.MapCommonStyleBtn.frame.origin.x += 221
            self.MapSateStyleBtn.frame.origin.x += 157
            self.MapNightStyleBtn.frame.origin.x += 93
        }, completion: nil)
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

extension NaviViewController: AMapSearchDelegate, MAMapViewDelegate, AMapLocationManagerDelegate, SearchVCDelegate {
   
    func didSelectLocationTipInTableView(selectedTip: AMapTip) {
        pointAnnotation.title = selectedTip.name
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(selectedTip.location.latitude) ,longitude: CLLocationDegrees(selectedTip.location.longitude))
        mapView.addAnnotation(pointAnnotation)
        mapView.setCenter(pointAnnotation.coordinate, animated: true)
        
        if ifTouchInfoViewLoaded == false {
            TouchName.text = selectedTip.name
            TouchAddress.text = selectedTip.address
            TouchInfoView.addSubview(TouchName)
            TouchInfoView.addSubview(TouchAddress)
            TouchInfoView.addSubview(TouchRoadPlanBtn)
            ifTouchInfoViewLoaded = true
            TouchInfoView.isHidden = false
            //定位按钮空位
            MyLocationBtn.frame.origin.y = MyLocationBtn.frame.origin.y - 100
            self.view.addSubview(TouchInfoView)
        }else{
            TouchName.text = selectedTip.name
            TouchAddress.text = selectedTip.address
            if TouchInfoView.isHidden == true {
                MyLocationBtn.frame.origin.y = MyLocationBtn.frame.origin.y - 100
                TouchInfoView.isHidden = false
            }
        }
        
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


