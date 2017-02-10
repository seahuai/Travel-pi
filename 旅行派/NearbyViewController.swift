//
//  NearbyViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/6.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit


class NearbyViewController: UIViewController {

    fileprivate var hisOffsetY: CGFloat = 0
    
    //MARK:百度地图相关
    @IBOutlet weak var baiduMapView: BMKMapView!
    fileprivate lazy var locationService: BMKLocationService = {
        let service = BMKLocationService()
        return service
    }()
    fileprivate lazy var poiSearcher: BMKPoiSearch = {
        let searcher = BMKPoiSearch()
        return searcher
    }()
    fileprivate var nearLoaction: CLLocation?{
        didSet{
            coordinate = nearLoaction?.coordinate
        }
    }
    var coordinate: CLLocationCoordinate2D?{
        didSet{
            if coordinate != nil{
                poiInfos.removeAll()
                baiduMapView.centerCoordinate = coordinate!
            }
        }
    }
    
    
    fileprivate var annotations: [BMKAnnotation] = [BMKAnnotation]()
    fileprivate var poiInfos: [BMKPoiInfo] = [BMKPoiInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        baiduMapView.delegate = self
        locationService.delegate = self
        poiSearcher.delegate = self
        if coordinate == nil{ locationService.startUserLocationService() }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        baiduMapView.delegate = nil
        locationService.delegate = nil
        poiSearcher.delegate = nil
        locationService.stopUserLocationService()
    }

}

//MARK:代理

//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let dis:CGFloat = 10
//        let targetY: CGFloat = targetContentOffset.pointee.y
//        //隐藏
//        if hisOffsetY + dis < targetY{
//            tabBarAnimation(hiding: true)
//        }
//        //显示
//        if hisOffsetY + dis > targetY{
//            tabBarAnimation(hiding: false)
//        }
//        hisOffsetY = targetContentOffset.pointee.y
//    }
//    
//    fileprivate func tabBarAnimation(hiding: Bool){
//        UIView.animate(withDuration: 0.3, animations: {
//            self.tabBarController?.tabBar.frame.origin.y = hiding ? UIScreen.main.bounds.height : UIScreen.main.bounds.height - 49
//        })
//    }

//MARK:点击tip代理
extension NearbyViewController: TipCollectionViewDelegate{
    func didSelect(tip: String) {
        if nearLoaction == nil{print("获取当前位置中")}
        else{
            if coordinate != nil{
                sendSearchRequest(coordinate: coordinate!, keyword: tip)
            }
        }
    }
}
//MARK:地图相关方法
extension NearbyViewController: BMKMapViewDelegate, BMKLocationServiceDelegate, BMKPoiSearchDelegate {
    //MARK:-地图代理
    func mapview(_ mapView: BMKMapView!, onDoubleClick coordinate: CLLocationCoordinate2D) {
//        print(coordinate)
    }
    
    func mapView(_ mapView: BMKMapView!, regionDidChangeAnimated animated: Bool) {
//        print(mapView.region.span)
    }
    
    func mapView(_ mapView: BMKMapView!, didSelect view: BMKAnnotationView!) {
//        print(view.annotation.title!())
    }
    //MARK:个人定位代理
    func didUpdate(_ userLocation: BMKUserLocation!) {
        if let location = userLocation{
            updateLocationService(userLocation: location)
            locationService.stopUserLocationService()
        }
    }
    //MARK:-POI代理
    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        baiduMapView.removeAnnotations(baiduMapView.annotations)
        if errorCode == BMK_SEARCH_NO_ERROR{
            annotations.removeAll()
            poiInfos = poiResult.poiInfoList as! [BMKPoiInfo]
            for i in 0..<poiResult.poiInfoList.count{
                let info = poiResult.poiInfoList[i] as! BMKPoiInfo
                let item = BMKPointAnnotation()
                item.coordinate = info.pt
                item.title = info.name
                annotations.append(item)
            }
            baiduMapView.addAnnotations(annotations)
            baiduMapView.showAnnotations(annotations, animated: true)
        }else{
            poiInfos.removeAll()
        }
    }
       
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        let indentifier = "newAnnotation"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: indentifier)
        if view == nil{
            view = BMKAnnotationView(annotation: annotation, reuseIdentifier: indentifier)
        }
        view?.image = UIImage(named: "mapViewMiddle")
        return view
    }
    //MARK:方法
    fileprivate func sendCitySearchRequeset(city: String, keyword: String){
        let option = BMKCitySearchOption()
        option.city = city
        option.keyword = keyword
        option.pageCapacity = 10
        poiSearcher.poiSearch(inCity: option)
    }
    
    fileprivate func sendSearchRequest(coordinate: CLLocationCoordinate2D, keyword: String){
        let option = BMKNearbySearchOption()
        option.location = coordinate
        option.keyword = keyword
        option.pageCapacity = 20
        poiSearcher.poiSearchNear(by: option)
    }
    
    fileprivate func updateLocationService(userLocation: BMKUserLocation){
        self.nearLoaction = userLocation.location
        baiduMapView.centerCoordinate = userLocation.location.coordinate
        baiduMapView.showsUserLocation = false
        baiduMapView.userTrackingMode = BMKUserTrackingModeFollow
        baiduMapView.showsUserLocation = true
    }
}
