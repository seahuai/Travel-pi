//
//  NearbyViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/6.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import SVProgressHUD

class NearbyViewController: UIViewController {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var collectionViewBottomCon: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    fileprivate var routes: [Int] = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        setUp()
        setUpCollectionView()
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
        baiduMapView.showsUserLocation = false
    }

}

//MARK: 处理搜索结果框和搜索框
extension NearbyViewController: UITextFieldDelegate{
    fileprivate func setUp(){
        collectionViewBottomCon.constant = -UIScreen.main.bounds.height * 0.2
        searchField.delegate = self
        searchField.returnKeyType = .search
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        poiInfos.removeAll()
        baiduMapView.removeAnnotations(annotations)
        collectionView.reloadData()
        collectionViewBottomCon.constant = -UIScreen.main.bounds.height * 0.2
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var finish = false
        if !textField.text!.isEmpty{
            if coordinate == nil {SVProgressHUD.showError(error: "无法获取当前位置", interval: 1) }
            else{
                sendSearchRequest(coordinate: coordinate!, keyword: textField.text!)
            }
            finish = true
        }else{
            print("内容不能为空")
        }
        return finish
    }
}

//MARK: 搜索结果的处理
extension NearbyViewController: UICollectionViewDelegate, UICollectionViewDataSource, PoiResultCellDelegate{
    fileprivate func setUpCollectionView(){
        collectionView.layer.cornerRadius = 5
        collectionView.clipsToBounds = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.collectionViewLayout = flowLayout()
        collectionView.register(UINib(nibName: "PoiResultCell", bundle: nil), forCellWithReuseIdentifier: "PoiResultCell")
    }
    
    fileprivate func flowLayout() -> UICollectionViewFlowLayout{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 0.2 * baiduMapView.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return poiInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PoiResultCell", for: indexPath) as! PoiResultCell
        let order = indexPath.row + 1
        cell.order = order
        cell.addButton.isEnabled = routes.contains(order) ? false : true
        cell.info = poiInfos[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = collectionView.contentOffset.x / collectionView.bounds.width
        let info = poiInfos[Int(index)]
        let span = BMKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = BMKCoordinateRegion(center: info.pt, span: span)
        baiduMapView.setRegion(region, animated: true)
        
    }
    //MARK:收起搜索栏的方法
    func down() {
        collectionViewBottomCon.constant = -UIScreen.main.bounds.height * 0.2
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func add(order: Int) {
        routes.append(order)
    }
}


//MARK:地图相关方法
extension NearbyViewController: BMKMapViewDelegate, BMKLocationServiceDelegate, BMKPoiSearchDelegate {
    //MARK:-地图代理
    func mapView(_ mapView: BMKMapView!, regionWillChangeAnimated animated: Bool) {
        searchField.resignFirstResponder()
//        print("la:\(mapView.region.span.latitudeDelta)-lo\(mapView.region.span.longitudeDelta)")
    }
    
    func mapView(_ mapView: BMKMapView!, regionDidChangeAnimated animated: Bool) {
        
    }
    
    func mapView(_ mapView: BMKMapView!, didSelect view: BMKAnnotationView!) {
        let annotation = view.annotation
        if collectionViewBottomCon.constant < 0 {
            collectionViewBottomCon.constant = 10
            UIView.animate(withDuration: 0.3, animations: { 
                self.view.layoutIfNeeded()
            })
        }
        for i in 0..<annotations.count{
            if annotation!.title!() == annotations[i].title!(){
                collectionView.scrollToItem(at: IndexPath(item: i, section: 0), at: [], animated: true)
                return
            }
        }
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
            collectionView.reloadData()
            collectionViewBottomCon.constant = 10
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
