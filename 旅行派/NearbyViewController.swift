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
    fileprivate var nearLoaction: CLLocation?{
        didSet{
            coordinate = nearLoaction?.coordinate
        }
    }
    fileprivate var city: String?{
        didSet{
//            poiInfos.removeAll()
//            tableView.reloadSections([1], with: .none)
        }
    }//城市为空的时候才开启定位
    
    var coordinate: CLLocationCoordinate2D?{
        didSet{
            if coordinate != nil{
                poiInfos.removeAll()
                baiduMapView.centerCoordinate = coordinate!
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                isFound = false
                tableView.reloadSections([1], with: .none)
            }
            
        }
    }
    
    
    fileprivate var annotations: [BMKAnnotation] = [BMKAnnotation]()
    fileprivate var poiInfos: [BMKPoiInfo] = [BMKPoiInfo]()
    fileprivate var isFound: Bool = false
    
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

extension NearbyViewController{
    fileprivate func setUpTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: baiduMapView.frame.maxY - 44, left: 0, bottom: 0, right: 0)
        tableView.register(SectionOneCell.self, forCellReuseIdentifier: "SectionOneCell")
        tableView.register(UINib(nibName: "SectionTwoCell", bundle: nil), forCellReuseIdentifier: "SectionTwoCell")
    }
    
    fileprivate func setUpMapView(){
//        baiduMapView.region.span = BMKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.6)
    }
}
//MARK:通知相关
extension NearbyViewController{
}

extension NearbyViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 200: 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let head: String? = isFound ? "为你找到" : "未找到相关内容"
        return section == 0 ? "寻找" : head
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : poiInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionOneCell", for: indexPath) as! SectionOneCell
            cell.delegate = self
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTwoCell", for: indexPath) as! SectionTwoCell
            cell.item = poiInfos[indexPath.row]
            return cell
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let distance: CGFloat = 100
        delegate?.nearByTableView(offset: offset - distance)
    }
}
//MARK:代理
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
        print(view.annotation.title!())
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
            isFound = true
        }else{
            poiInfos.removeAll()
            isFound = false
            print("检索失败")
        }
        tableView.reloadSections([1], with: .none)
        if isFound{ tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: true) }
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
        option.pageCapacity = 10
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
