//
//  HomeViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/25.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    @IBOutlet weak var destinationTableView: UITableView!
    @IBOutlet weak var displayScrollView: UIScrollView!
    
    //MARK:定位工具
    fileprivate var once = true
    var location = CLLocation(){
        didSet{
            if once{
                getNearByDestinations(location: location)
                once = false
            }
        }
    }
    fileprivate lazy var locationTool: LocationTool = LocationTool { [weak self] (location) in
        self?.location = location
    }
    //MARK:模型属性
    fileprivate var NBdestinations: [Destination] = [Destination]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        setUpNavigationBar()
        setUpTableView()
        setUpScrollView()
        setUp()
    }
}


extension HomeViewController{
    
    fileprivate func setUp(){
        locationTool.isUpdate = true
    }
    
    fileprivate func setUpNavigationBar(){
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    fileprivate func setUpTableView(){
        destinationTableView.delegate = self
        destinationTableView.dataSource = self
    }
    
    fileprivate func setUpScrollView(){
        displayScrollView.delegate = self
    }
}

//MARK:tableView-DataSource-Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return 3
    //    }
    //
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 10
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "附近"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView----\(NBdestinations.count)")
        return NBdestinations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell", for: indexPath) as! DestinationCell
        let destination = NBdestinations[indexPath.row]
        cell.destination = destination
        return cell
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

//MARK:scrollView-Delegate
extension HomeViewController: UIScrollViewDelegate{
    
}

//MARK:获取位置及附近景点
extension HomeViewController{
    
    fileprivate func getNearByDestinations(location: CLLocation){
        print("getNearByDestinations----\(location)")
        
        NetWorkTool.sharedInstance.getNearbyDestination(location: location) { (error, result) in
            for dict in result!{
                let des = Destination(dict: dict)
                self.NBdestinations.append(des)
            }
            self.locationTool.isUpdate = false
            self.destinationTableView.reloadData()
            
        }
    }
}




