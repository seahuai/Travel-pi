//
//  CityListViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/11.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var historyDes: [Destination] = [Destination]()
    fileprivate let sectionsName: [String] = ["猜你喜欢","热门地区", "其它", "历史位置"]
    //MARK:地理编码
//    fileprivate lazy var geoSearcher: BMKGeoCodeSearch = {
//        let geo = BMKGeoCodeSearch()
//        return geo
//    }()
//    fileprivate lazy var locationService: BMKLocationService = {
//        let service = BMKLocationService()
//        return service
//    }()
//    fileprivate var address: String?{
//        didSet{
//            collectionView.reloadSections([0])
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
   
}
extension CityListViewController: BMKGeoCodeSearchDelegate, BMKLocationServiceDelegate{
//    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
//        if error == BMK_SEARCH_NO_ERROR{
//            address = result.address
//        }
//    }
//    
//    func didUpdate(_ userLocation: BMKUserLocation!) {
//        if userLocation != nil{
//            locationService.stopUserLocationService()
//            let coordinate = userLocation.location.coordinate
//            let option = BMKReverseGeoCodeOption()
//            option.reverseGeoPoint = coordinate
//            geoSearcher.reverseGeoCode(option)
//        }
//    }
}

extension CityListViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    fileprivate func setUp(){
        collectionView.dataSource = self
        collectionView.collectionViewLayout = setUpLayout()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: "CityCell", bundle: nil), forCellWithReuseIdentifier: "CityCell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CityHeaderView")
    }
    
    fileprivate func setUpLayout() -> UICollectionViewFlowLayout{
        let layout = UICollectionViewFlowLayout()
        let viewW = view.bounds.size.width
        let space: CGFloat = 10
        let width = (viewW - 5 * space) / 4
        layout.itemSize = CGSize(width: width, height: 25)
        layout.headerReferenceSize = CGSize(width: viewW, height: 40)
        return layout
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionsName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{return CityList.sharedInstance.nearDestination.count} else
        if section == 1{return CityList.sharedInstance.hotDestination.count} else
        if section == 2{return CityList.sharedInstance.otherDestination.count}else
        if section == 3{return historyDes.count}
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath) as! CityCell
        var destination: Destination?
        var coordinate: CLLocationCoordinate2D?
        if indexPath.section == 0{
            destination = CityList.sharedInstance.nearDestination[indexPath.item]
        }
        if indexPath.section == 1{
            destination = CityList.sharedInstance.hotDestination[indexPath.item]
        }
        if indexPath.section == 2{
            destination = CityList.sharedInstance.otherDestination[indexPath.item]
        }
        if indexPath.section == 3{
            destination = historyDes[indexPath.item]
        }
        if destination != nil{coordinate = CLLocationCoordinate2D(latitude: destination!.lat, longitude: destination!.lng)}
        cell.cityName = destination?.name
        cell.coordinate = coordinate
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reuseView = UICollectionReusableView()
        if kind == UICollectionElementKindSectionHeader{
            reuseView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CityHeaderView", for: indexPath)
            if reuseView.subviews.count != 0{
                reuseView.subviews[0].removeFromSuperview()
            }
            let label = UILabel()
            label.text = sectionsName[indexPath.section]
            label.frame = CGRect(x: 10, y: 10, width: 100, height: 20)
            label.textColor = UIColor.lightGray
            label.font = UIFont.systemFont(ofSize: 14)
            reuseView.addSubview(label)
        }
        return reuseView
    }
}
//MARK:通知相关
extension CityListViewController{
    
}
