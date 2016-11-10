//
//  NearbyViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/6.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

protocol NearByTableViewDelegate {
    func nearByTableView(offset: CGFloat)
}

class NearbyViewController: UIViewController {

    //代理属性
    var delegate: NearByTableViewDelegate?
    @IBOutlet weak var tableView: UITableView!
    
    
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
    fileprivate var loaction: CLLocation?{
        didSet{
            sendSearchRequest()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        setUpTableView()
        setUpMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        baiduMapView.delegate = self
        locationService.delegate = self
        poiSearcher.delegate = self
        locationService.startUserLocationService()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        baiduMapView.delegate = nil
        locationService.delegate = nil
        poiSearcher.delegate = nil
        locationService.stopUserLocationService()
    }

}

extension NearbyViewController{
    fileprivate func setUpTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: baiduMapView.frame.maxY - 44, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate func setUpMapView(){
        baiduMapView.region.span = BMKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.6)
        
    }
}

extension NearbyViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 200 : 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "寻找" : nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.section)-\(indexPath.row))"
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let distance: CGFloat = 100
        delegate?.nearByTableView(offset: offset - distance)
    }
}

extension NearbyViewController: BMKMapViewDelegate, BMKLocationServiceDelegate, BMKPoiSearchDelegate{
    func mapview(_ mapView: BMKMapView!, onDoubleClick coordinate: CLLocationCoordinate2D) {
//        print(coordinate)
    }
    
    func mapView(_ mapView: BMKMapView!, regionDidChangeAnimated animated: Bool) {
//        print(mapView.region.span)
    }
    
    func mapView(_ mapView: BMKMapView!, didSelect view: BMKAnnotationView!) {
        print(view.annotation.title!())
    }
    
    func didUpdate(_ userLocation: BMKUserLocation!) {
        if let location = userLocation{
            updateLocationService(userLocation: location)
            locationService.stopUserLocationService()
        }
    }
    
    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        baiduMapView.removeAnnotations(baiduMapView.annotations)
        if errorCode == BMK_SEARCH_NO_ERROR{
            var annotations = [BMKPointAnnotation]()
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
            print("检索失败")
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
    
    fileprivate func sendSearchRequest(){
        let option = BMKNearbySearchOption()
        option.location = self.loaction!.coordinate
        option.keyword = "小吃"
        option.pageCapacity = 10
        poiSearcher.poiSearchNear(by: option)
    }
    
    fileprivate func updateLocationService(userLocation: BMKUserLocation){
        self.loaction = userLocation.location
        baiduMapView.centerCoordinate = userLocation.location.coordinate
        baiduMapView.showsUserLocation = false
        baiduMapView.userTrackingMode = BMKUserTrackingModeFollow
        baiduMapView.showsUserLocation = true
    }
}
