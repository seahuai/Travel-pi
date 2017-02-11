//
//  HomeViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/25.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import CoreLocation
import SnapKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var destinationTableView: UITableView!
    @IBOutlet weak var displayScrollView: UIScrollView!
    
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    //dispalyView的原始高度
    fileprivate var displayViewHeight: CGFloat = 0
    fileprivate var tableViewOrginalY: CGFloat = 0
    @IBOutlet weak var displayViewHeightCon: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightCon: NSLayoutConstraint!
    //MARK:定位工具
//    fileprivate var once = true
    var location = CLLocation()
    fileprivate lazy var locationTool = LocationTool()
    
    //MARK:模型属性
    fileprivate var NBdestinations: [Destination] = [Destination]()
    fileprivate var Hotdestinations: [Destination] = [Destination]()
    fileprivate var Otherdestinations: [Destination] = [Destination]()
    fileprivate var ChinaHotdestinations: [Destination] = [Destination]()
    fileprivate var CellModels:[String: [Destination]] = [String: [Destination]](){
        didSet{
            destinationTableView.reloadData()
            destinationTableView.mj_header.endRefreshing()
        }
    }
    fileprivate var WeekAlbum: TravelAlbum?{
        didSet{
            self.view.layoutIfNeeded()
            setUpScrollView(count: WeekAlbum!.travelNotes.count)
            startTimer()
        }
    }
    //MARK:定时器
    fileprivate var timer: Timer?
    
    //MARK:Cell标题
    fileprivate var cellTitle: [String] = ["周边","国内","亚洲","其它"]
    
    //MARK:控制器
    fileprivate lazy var findMoreViewController: FindMoreViewController = FindMoreViewController()
//    fileprivate lazy var profileViewController: ProfileViewController = ProfileViewController()
    fileprivate lazy var albumViewController: AlbumDetailViewController = AlbumDetailViewController()
    //MARK:动画
    fileprivate lazy var animator: DrawerAnimator = DrawerAnimator()
    
    //MARK:右滑界面参数
    fileprivate let menuWidth: CGFloat = UIScreen.main.bounds.width * 0.8
    fileprivate var isOpening: Bool = false
    
    //MARK:导航栏控件
    fileprivate var toolBar: UIToolbar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.layoutIfNeeded()
        setUpNavigationBar()
        setUpTableView()
        setUpNotification()
        setUp()
        setUpToolBar()
        setUpTableViewRefresh()

        getWeekAlbum()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = false
        displayViewHeight(offset: tableViewOrginalY + destinationTableView.contentOffset.y)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK:通知
extension HomeViewController{
    fileprivate func setUpNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushFindMore(note:)), name: NSNotification.Name(rawValue: PushFindMoreVCNote), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushDetail(note:)), name: NSNotification.Name(rawValue: SelectePicCellNote), object: nil)
    }
    
    @objc private func pushDetail(note: Notification){
        let des = note.userInfo?["destination"] as! Destination
        let detailVc = DetailViewController()
        detailVc.hidesBottomBarWhenPushed = true
        detailVc.destination = des
        toolBar?.alpha = 0
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
    
    @objc private func pushFindMore(note: Notification){
        let id = note.userInfo?["cellId"] as! String
        findMoreViewController.destinations = CellModels[id]!
        findMoreViewController.hidesBottomBarWhenPushed = true
        toolBar?.alpha = 0
        self.navigationController?.pushViewController(findMoreViewController, animated: true)
    }
}


extension HomeViewController: LocationDelegate{
    
    func getLocation(location: CLLocation) {
        self.location = location
        getNearByDestinations(location: location)
    }
    
    fileprivate func setUp(){
//        locationTool.isUpdate = true
        locationTool.delegate = self
        
        displayViewHeight = displayViewHeightCon.constant
        tableViewOrginalY = destinationTableView.contentInset.top
        automaticallyAdjustsScrollViewInsets = false
    }
    
    fileprivate func setUpNavigationBar(){
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(white: 0.9, alpha: 0.9)]
        navigationController?.navigationBar.barStyle = .black
    }
    
    fileprivate func setUpToolBar(){
        toolBar = UIToolbar(frame: CGRect(x: 0, y: -20, width: UIScreen.main.bounds.width, height: 84))
        toolBar!.barStyle = .default
        toolBar!.alpha = 0
        navigationController?.view.insertSubview(toolBar!, at: 1)

    }
   
    fileprivate func setUpTableView(){
        destinationTableView.delegate = self
        destinationTableView.dataSource = self
        destinationTableView.separatorStyle = .none
        destinationTableView.contentInset = UIEdgeInsets(top: displayViewHeightCon.constant, left: 0, bottom: 0, right: 0)
           }
    
     //MARK: 使用MJRefresh框架
    fileprivate func setUpTableViewRefresh(){
        let header =  MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refreshTableView))
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放刷新", for: .pulling)
        header?.setTitle("加载中", for: .refreshing)
        header?.lastUpdatedTimeLabel.isHidden = true
        destinationTableView.mj_header = header
        
        destinationTableView.mj_header.beginRefreshing()
    }
    
    //MARK: 刷新方法
    @objc fileprivate func refreshTableView(){
        getChinaHotDestination()
        getAsiaDestinations()
        getEuropeDestinations()
        locationTool.start()
        //----->定位工具开启后会自动获取附近的位置
//        getNearByDestinations(location: location)
    }

}

//MARK:处理导航栏按钮的点击
extension HomeViewController{
    @IBAction func leftButtonClick(_ sender: UIBarButtonItem) {
        present(ProfileViewController.shared, animated: true) {}
    }
    
    @IBAction func searchButtonClick(_ sender: AnyObject) {
        present(SearchViewController.shared, animated: true, completion: nil)
    }
    
    
}


//MARK:tableView-DataSource-Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("tableView----\(NBdestinations.count)")
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell", for: indexPath) as! DestinationCell
        
        var cellId: String = ""
        
        if indexPath.row == 0{cellId = "NearBy"}
        if indexPath.row == 1{cellId = "China"}
        if indexPath.row == 2{cellId = "Hot"}
        if indexPath.row == 3{cellId = "Others"}
        
        if CLLocationManager.authorizationStatus().rawValue == 2 && cellId == "NearBy"{
            cell.cellTitleLabel.text = "无法加载"
            cell.warnLabel.isHidden = false
            cell.setGpsOrNot = true
        }
        
        guard let destinations = CellModels[cellId] else {
            return cell
        }
        
        if destinations.count > 6{
            for i in 0..<6{
                if cell.destinations.count < 6{
                    cell.destinations.append(destinations[i])
                }
            }
        }else{
            cell.destinations = destinations
        }
        cell.warnLabel.isHidden = true
        cell.cellTitleLabel.text = cellTitle[indexPath.row]
        cell.cellId = cellId
        cell.setGpsOrNot = false
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
    fileprivate func displayViewHeight(offset: CGFloat){
        var height = displayViewHeight - offset
        //        print(height)
        if height <= 64{
            height = 64
            navigationItem.title = "热门城市"
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]

        }else{
            navigationItem.title = "每周精选"
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        }
        
        var alpha = 64 / height - 0.2
        if alpha <= 0{
            alpha = 0
        }
        toolBar?.alpha = alpha
        
        displayViewHeightCon.constant = height
        self.displayScrollView.layoutIfNeeded()
    }
}



//MARK:轮播图视图
extension HomeViewController: UIScrollViewDelegate{
    
    fileprivate func startTimer(){
        timer = Timer(timeInterval: 2, target: self, selector: #selector(self.autoDisplay), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .defaultRunLoopMode)
    }
    
    fileprivate func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func autoDisplay(){
        var offset = displayScrollView.contentOffset.x
        let screenW = UIScreen.main.bounds.width
        offset += screenW
        if (offset >= displayScrollView.contentSize.width){
            offset = 0
        }
        
        UIView.animate(withDuration: 0.5) { 
            self.displayScrollView.contentOffset = CGPoint(x: offset, y: 0)
        }
    }
    
    fileprivate func setUpScrollView(count: Int){
        let screenW = UIScreen.main.bounds.width
        displayScrollView.delegate = self
        displayScrollView.contentSize = CGSize(width: screenW * CGFloat(count), height: 0)
        displayScrollView.isPagingEnabled = true
        
        for i in 0..<count{
            let imageView = UIImageView()
            imageView.tag = i
            displayScrollView.addSubview(imageView)
            imageView.frame = displayScrollView.bounds
            
//            print("\(i):\(imageView.frame)")
            imageView.frame.origin = CGPoint(x: screenW * CGFloat(i), y: 0)
            imageView.backgroundColor = UIColor.clear
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.imageViewTap(sender:)))
            imageView.addGestureRecognizer(tapGes)
            imageView.isUserInteractionEnabled = true
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
                        
            if let urlStr = WeekAlbum?.travelNotes[i]._contents[0].photo_url{
                let url = URL(string: urlStr)
                imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "empty_picture"))
            }
        }
        
    }
    
    @objc private func imageViewTap(sender: UIGestureRecognizer){
        let index = sender.view!.tag
        print(index)
        //注意！！这里需要向传album模型再传索引
        albumViewController.album = WeekAlbum
        albumViewController.index = index
        let albumNavigationVC = UINavigationController(rootViewController: albumViewController)
        present(albumNavigationVC , animated: true) {}
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == displayScrollView{
            stopTimer()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == displayScrollView{
            startTimer()
        }
    }

}






//MARK:获取景点
extension HomeViewController{
    //MARK:-附近
    fileprivate func getNearByDestinations(location: CLLocation){
//        print("getNearByDestinations----\(location)")
        
        NetWorkTool.sharedInstance.getNearbyDestination(location: location) { (error, result) in
            if error != nil{print(error);self.destinationTableView.mj_header.endRefreshing();return}
            for dict in result!{
                let des = Destination(dict: dict)
                self.NBdestinations.append(des)
            }
//            self.locationTool.isUpdate = false
            if  self.CellModels["NearBy"] == nil{
                self.CellModels["NearBy"] = self.NBdestinations
            }
            //            self.destinationTableView.reloadData()
            self.destinationTableView.mj_header.endRefreshing()
        }
    }
    //MARK:中国热门旅游城市
    fileprivate func getChinaHotDestination(){
        NetWorkTool.sharedInstance.getHotDestination(area: .China) { (error, result) in
            if error != nil{print(error);self.destinationTableView.mj_header.endRefreshing();return}
            if let result = result{
                for dict in result{
                    let des = Destination(dict: dict)
                    self.ChinaHotdestinations.append(des)
                }
            }
            if  self.CellModels["China"] == nil{
                self.CellModels["China"] = self.ChinaHotdestinations
            }
            self.destinationTableView.mj_header.endRefreshing()
        }
    }
    
    //MARK:-热门
    fileprivate func getAsiaDestinations(){
        NetWorkTool.sharedInstance.getHotDestination(area: .Asia) { (error, result) in
            if error != nil{print(error);self.destinationTableView.mj_header.endRefreshing();return}
            if let result = result{
                for dict in result{
                    let des = Destination(dict: dict)
                    self.Hotdestinations.append(des)
                }
            }
            if  self.CellModels["Hot"] == nil{
                self.CellModels["Hot"] = self.Hotdestinations
            }
            self.destinationTableView.mj_header.endRefreshing()
        }
    }
    
    fileprivate func getEuropeDestinations(){
        NetWorkTool.sharedInstance.getHotDestination(area: .Europe) { (error, result) in
            if error != nil{print(error);self.destinationTableView.mj_header.endRefreshing();return}
            if let result = result{
                for dict in result{
                    let des = Destination(dict: dict)
                    self.Otherdestinations.append(des)
                }
            }
            
            if self.CellModels["Others"] == nil{
                self.CellModels["Others"] = self.Otherdestinations
            }
            self.destinationTableView.mj_header.endRefreshing()
        }
    }
    
}

//MARK:获取每周精选
extension HomeViewController{
    fileprivate func getWeekAlbum(){
        NetWorkTool.sharedInstance.getWeekChoice { (error, result) in
            if error != nil{print(error); return}
            if let result = result{
                let album = TravelAlbum(dict: result)
               self.WeekAlbum = album
            }
        }
    }
}




