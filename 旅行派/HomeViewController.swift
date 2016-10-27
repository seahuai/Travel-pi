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
    
    //dispalyView的原始高度
    
    fileprivate var displayViewHeight: CGFloat = 0
    fileprivate var tableViewOrginalY: CGFloat = 0
    @IBOutlet weak var displayViewHeightCon: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightCon: NSLayoutConstraint!
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
    fileprivate var Hotdestinations: [Destination] = [Destination]()
    fileprivate var CellModels:[String: [Destination]] = [String: [Destination]]()
    
    //MARK:Cell标题
    fileprivate var cellTitle: [String] = ["附近的城市","亚洲热门城市","其它热门城市"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        setUpNavigationBar()
        setUpTableView()
        setUpScrollView()
        setUp()
        
        getHotDestinations(area: .Asia)
    }
}


extension HomeViewController{
    
    fileprivate func setUp(){
        locationTool.isUpdate = true
        displayViewHeight = displayViewHeightCon.constant
        tableViewOrginalY = destinationTableView.contentInset.top
        automaticallyAdjustsScrollViewInsets = false
    }
    
    fileprivate func setUpNavigationBar(){
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
    }
    
    fileprivate func setUpTableView(){
        destinationTableView.delegate = self
        destinationTableView.dataSource = self
        destinationTableView.separatorStyle = .none
        destinationTableView.contentInset = UIEdgeInsets(top: displayViewHeightCon.constant, left: 0, bottom: 0, right: 0)

    }
    
    fileprivate func setUpScrollView(){
        displayScrollView.delegate = self

    }
}

//MARK:tableView-DataSource-Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView----\(NBdestinations.count)")
        return CellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell", for: indexPath) as! DestinationCell
        var cellId: String = ""
        
        if indexPath.row == 0{cellId = "NearBy"}
        if indexPath.row == 1{cellId = "Hot"}
        if indexPath.row == 2{}
        
        let destinations = CellModels[cellId]
        if destinations!.count > 6{
            for i in 0..<6{ cell.destinations.append(destinations![i]) }
        }else{
            cell.destinations = destinations!
        }
        cell.cellTitleLabel.text = cellTitle[indexPath.row]
        cell.selectionStyle = .none
        return cell
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == destinationTableView{
            let offset: CGFloat = destinationTableView.contentOffset.y + tableViewOrginalY
            displayViewHeight(offset: offset)
        }
    }
    
    //展示页面的变化
    private func displayViewHeight(offset: CGFloat){
        var height = displayViewHeight - offset
        print(height)
        if height <= 64{
            height = 64
        }
        displayViewHeightCon.constant = height
        self.displayScrollView.layoutIfNeeded()
    }
}

//MARK:scrollView-Delegate
extension HomeViewController: UIScrollViewDelegate{
    
}

//MARK:获取景点
extension HomeViewController{
    //MARK:-附近
    fileprivate func getNearByDestinations(location: CLLocation){
        print("getNearByDestinations----\(location)")
        
        NetWorkTool.sharedInstance.getNearbyDestination(location: location) { (error, result) in
            if error != nil{print(error); return}
            for dict in result!{
                let des = Destination(dict: dict)
                self.NBdestinations.append(des)
            }
            self.locationTool.isUpdate = false
            self.CellModels["NearBy"] = self.NBdestinations
            self.destinationTableView.reloadData()
        }
    }
    //MARK:-热门
    fileprivate func getHotDestinations(area: Area){
        NetWorkTool.sharedInstance.getHotDestination(area: area) { (error, result) in
            if error != nil{print(error); return}
            if let result = result{
                for dict in result{
                    let des = Destination(dict: dict)
                    self.Hotdestinations.append(des)
                }
            }
            self.CellModels["Hot"] = self.Hotdestinations
            self.destinationTableView.reloadData()
        }
    }
    
}




