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
    fileprivate var Otherdestinations: [Destination] = [Destination]()
    fileprivate var CellModels:[String: [Destination]] = [String: [Destination]](){
        didSet{
            destinationTableView.reloadData()
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
    fileprivate var cellTitle: [String] = ["附近的城市","亚洲热门城市","其它热门城市"]
    
    //MARK:控制器
    fileprivate lazy var findMoreViewController: FindMoreViewController = FindMoreViewController()
    fileprivate lazy var profileViewController: ProfileViewController = ProfileViewController()
    //MARK:动画
    fileprivate lazy var animator: FindMoreVCAnimator = FindMoreVCAnimator()
    
    //MARK:右滑界面参数
    fileprivate let menuWidth: CGFloat = UIScreen.main.bounds.width * 0.4
    fileprivate var isOpening: Bool = false
    
    //MARK:导航栏控件
    fileprivate var toolBar: UIToolbar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        setUpNavigationBar()
        setUpTableView()
        setUpNotification()
        setUpSlideMenu()
        setUp()
        
        
        getAsiaDestinations()
        getEuropeDestinations()
        getWeekAlbum()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
        toolBar = UIToolbar(frame: CGRect(x: 0, y: -20, width: UIScreen.main.bounds.width, height: 64))
        toolBar!.barStyle = .default
        toolBar!.alpha = 0
        navigationController?.navigationBar.insertSubview(toolBar!, at: 0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(white: 0.9, alpha: 0.9)]
    }
    
    fileprivate func setUpTableView(){
        destinationTableView.delegate = self
        destinationTableView.dataSource = self
        destinationTableView.separatorStyle = .none
        destinationTableView.contentInset = UIEdgeInsets(top: displayViewHeightCon.constant, left: 0, bottom: 0, right: 0)
        
    }
    
}

//MARK:处理导航栏按钮的点击
extension HomeViewController{
    @IBAction func leftButtonClick(_ sender: UIBarButtonItem) {
        let duration: TimeInterval = 0.5
        if navigationController!.view.frame.origin.x / menuWidth == 0{
            UIView.animate(withDuration: duration, animations: {
               self.setToPercent(percent: 1.0)
            })
        }else{
            UIView.animate(withDuration: duration, animations: {
                self.setToPercent(percent: 0.0)
            })
        }
    }
}

//MARK:处理通知事件
extension HomeViewController{
    
    fileprivate func setUpNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushFindMoreVC(note:)), name: NSNotification.Name(rawValue: PicCollectionViewScrollNote), object: nil)
    }
    
    @objc fileprivate func pushFindMoreVC(note: Notification){
        let cellId = note.userInfo?["cellId"] as? String
        if let cellId = cellId{
            findMoreViewController.destinations = CellModels[cellId]!
            
            //            navigationController?.pushViewController(findMoreViewController, animated: true)
            //            let navigationVC = UINavigationController(rootViewController: findMoreViewController)
            //            navigationVC.transitioningDelegate = animator
            //            present(navigationVC, animated: true, completion: { })
            
            findMoreViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(findMoreViewController, animated: true)
            
        }
    }
    
    
    
}

//MARK:tableView-DataSource-Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("tableView----\(NBdestinations.count)")
        return CellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell", for: indexPath) as! DestinationCell
        var cellId: String = ""
        
        if indexPath.row == 0{cellId = "NearBy"}
        if indexPath.row == 1{cellId = "Hot"}
        if indexPath.row == 2{cellId = "Others"}
        
        
        guard let destinations = CellModels[cellId] else {
            return cell
        }
        
        if destinations.count > 6{
            for i in 0..<6{ cell.destinations.append(destinations[i]) }
        }else{
            cell.destinations = destinations
        }
        
        cell.cellTitleLabel.text = cellTitle[indexPath.row]
        cell.cellId = cellId
        
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
        //        print(height)
        if height <= 64{
            height = 64
            navigationItem.title = "热门城市"
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(colorLiteralRed: 27/255, green: 166/255, blue: 197/255, alpha: 1)]

        }else{
            navigationItem.title = "每周精选"
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(white: 0.9, alpha: 0.9)]
        }
        
        var alpha = 64 / height - 0.4
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
        if (offset > displayScrollView.contentSize.width){
            offset = 0
        }
        
        UIView.animate(withDuration: 0.5) { 
            self.displayScrollView.contentOffset = CGPoint(x: offset, y: 0)
        }
    }
    
    fileprivate func setUpScrollView(count: Int){
        let screenW = UIScreen.main.bounds.width
        displayScrollView.delegate = self
        displayScrollView.contentSize = CGSize(width: screenW * CGFloat(count - 1), height: 0)
        displayScrollView.isPagingEnabled = true
        
        for i in 0..<count{
            let imageView = UIImageView()
            imageView.tag = i
            displayScrollView.addSubview(imageView)
            imageView.frame = displayScrollView.bounds
            
            print("\(i):\(imageView.frame)")
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
            print(displayScrollView.contentSize)
        }
        
    }
    
    @objc private func imageViewTap(sender: UIGestureRecognizer){

    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("stop")
        if scrollView == displayScrollView{
            stopTimer()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == displayScrollView{
            startTimer()
        }
    }

}


//MARK:处理抽屉效果
extension HomeViewController{
    fileprivate func setUpSlideMenu(){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        view.addGestureRecognizer(pan)
        
        profileViewController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: UIScreen.main.bounds.height)
        navigationController?.view.addSubview(profileViewController.view)
    }
    
    
    @objc private func handleGesture(gesture: UIPanGestureRecognizer){
        
        let translation = gesture.translation(in: view)
        var progress: CGFloat = translation.x / menuWidth * (isOpening ? 1.0:-1.0)
        progress = min(max(progress, 0), 1)
        
        
        switch gesture.state {
        case .began:
            profileViewController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: UIScreen.main.bounds.height)
            let isOpen = navigationController!.view.frame.origin.x / menuWidth
            isOpening = isOpen == 1.0 ? false:true
            
            profileViewController.view.layer.shouldRasterize = true
            profileViewController.view.layer.rasterizationScale = UIScreen.main.scale
            
        case .changed:
            setToPercent(percent: isOpening ? progress : (1.0 - progress))
            
        case .ended:
            
            var targetProgress: CGFloat
            if (isOpening) {
                targetProgress = progress < 0.5 ? 0.0 : 1.0
            }else {
                targetProgress = progress < 0.5 ? 1.0 : 0.0
            }
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.setToPercent(percent: targetProgress)
                }, completion: { (_) -> Void in
                    // 记得关闭layer的缓存渲染
                    self.profileViewController.view.layer.shouldRasterize = false
            })
            
        default:
            break
        }
    }
    
    fileprivate func setToPercent(percent: CGFloat){
        navigationController?.view.frame.origin.x = menuWidth * percent
        
        profileViewController.view.alpha = max(0.2, percent)
        profileViewController.view.layer.transform = menuTransformPercent(percent: percent)
    }
    
    fileprivate func menuTransformPercent(percent: CGFloat) -> CATransform3D{
        var identity = CATransform3DIdentity
        identity.m34 = -1/1000
        
        let remainingPercent = 1.0 - percent
        let angle = CGFloat(-M_PI_2) * remainingPercent
        
        let rotation = CATransform3DRotate(identity, angle, 0, 1, 0)
        let translation = CATransform3DMakeTranslation(0, 0, 0)
        
        let transform = CATransform3DConcat(rotation, translation)
        
        return transform
        
    }

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
            
            //            self.destinationTableView.reloadData()
        }
    }
    //MARK:-热门
    fileprivate func getAsiaDestinations(){
        NetWorkTool.sharedInstance.getHotDestination(area: .Asia) { (error, result) in
            if error != nil{print(error); return}
            if let result = result{
                for dict in result{
                    let des = Destination(dict: dict)
                    self.Hotdestinations.append(des)
                }
            }
            self.CellModels["Hot"] = self.Hotdestinations
            //            self.destinationTableView.reloadData()
        }
    }
    
    fileprivate func getEuropeDestinations(){
        NetWorkTool.sharedInstance.getHotDestination(area: .Europe) { (error, result) in
            if error != nil{print(error); return}
            if let result = result{
                for dict in result{
                    let des = Destination(dict: dict)
                    self.Otherdestinations.append(des)
                }
            }
            self.CellModels["Others"] = self.Otherdestinations
            //            self.destinationTableView.reloadData()
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




