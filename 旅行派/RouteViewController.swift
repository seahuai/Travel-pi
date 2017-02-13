//
//  RouteViewController.swift
//  旅行派
//
//  Created by 张思槐 on 17/2/10.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD
class RouteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate let locTool = LocationTool()
    fileprivate var original: CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpLoctionTool()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locTool.start()
    }
    
    func reload(){
        if tableView != nil{
            tableView.reloadData()
        }
    }
}

extension RouteViewController: LocationDelegate{
    fileprivate func setUpLoctionTool(){
        locTool.delegate = self
    }
    
    func getLocation(location: CLLocation) {
        original = location.coordinate
    }
}



extension RouteViewController: UITableViewDelegate, UITableViewDataSource, RouteCellDelegate{
    fileprivate func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RouteCell", bundle: nil), forCellReuseIdentifier: "RouteCell")
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Route.shared.cellHeight(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Route.shared.routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as! RouteCell
        cell.info = Route.shared.routes[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Route.shared.routes[indexPath.row].cellHeight = Route.shared.routes[indexPath.row].cellHeight == 75 ? 115 : 75
        let cell = tableView.cellForRow(at: indexPath) as! RouteCell
        cell.hiddenButton = false
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let cell = tableView.cellForRow(at: indexPath) as! RouteCell
        cell.hiddenButton = true
        let delete = UITableViewRowAction(style: .destructive, title: "删除") { (_ ,_) in
            let index = Route.shared.routes[indexPath.row].index
            if let i = Route.shared.routesIndex.index(of: index) {
                Route.shared.routesIndex.remove(at: i)
            }
            Route.shared.routes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
        return [delete]
    }
    
    //transit、driving、walking
    func goWalk(name: String, location: CLLocationCoordinate2D) {
        loadRoad(mode: "walking", destination: location, name: name)
    }
    
    func byCar(name: String, location: CLLocationCoordinate2D) {
        loadRoad(mode: "driving", destination: location, name: name)
    }
    
    func byBus(name: String, location: CLLocationCoordinate2D) {
        loadRoad(mode: "transit", destination: location, name: name)
    }
    
    fileprivate func loadRoad(mode: String, destination: CLLocationCoordinate2D, name: String){
        if original == nil{
            locTool.start()
            SVProgressHUD.showInfo(info: "无法获取当前位置，请稍后再试", interval: 1)
            return
        }
        //http://api.map.baidu.com/direction?origin=latlng:34.264642646862,108.95108518068|name:我家&destination=大雁塔&mode=driving&region=西安&output=html&src=yourCompanyName|yourAppName
//        let src = "src=travelpi|travelpi"
//        let mode = "mode=\(mode)"
//        let destination = "destination=latlng:\(original!.latitude),\(original!.longitude)|name:\(name)"
//        let origin = "origin=latlng:\(original!.latitude),\(original!.longitude)|name:当前位置"
//        let urlStr = "http://api.map.baidu.com/direction?\(origin)&\(destination)&\(mode)&output=html&\(src)"
//        
//
        
        
        let baseUrl = "http://api.map.baidu.com/direction"
        let src = URLQueryItem(name: "src", value: "travelpi|travelpi")
        let mode = URLQueryItem(name: "mode", value: mode)
        let destination = URLQueryItem(name: "destination", value: "latlng:\(original!.latitude),\(original!.longitude)|name:\(name)")
        let origin = URLQueryItem(name: "origin", value: "latlng:\(original!.latitude),\(original!.longitude)|name:当前位置")
        let output = URLQueryItem(name: "output", value: "html")
        let region = URLQueryItem(name: "region", value: "中国")
        var urlCom = URLComponents(string: baseUrl)
        urlCom?.queryItems = [origin ,destination ,mode, output, src, region]
        guard let url = urlCom?.url else{ return }
    
        
        let navi = NaviViewController(url: url)
        navi.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(navi, animated: true)
     
        
      
    }
}
