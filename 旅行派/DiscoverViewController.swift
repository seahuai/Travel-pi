//
//  DiscoverViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/6.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    @IBOutlet weak var segementControl: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    fileprivate lazy var nearByViewController: NearbyViewController = NearbyViewController()
    fileprivate lazy var routeViewController: RouteViewController = RouteViewController()
    
    //地图界面加入行程之后传给父控制器，再由父控制器将值传递给子控制器
    fileprivate var routeInfos: [BMKPoiInfo] = [BMKPoiInfo]()
    fileprivate var newRoutes: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpChildViewController()
        setUpNote()
    }
}

extension DiscoverViewController{
    fileprivate func setUp(){
        automaticallyAdjustsScrollViewInsets = false
        
        scrollView.isScrollEnabled = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 2, height: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        segementControl.setTitle("地图", forSegmentAt: 0)
        segementControl.setTitle("行程", forSegmentAt: 1)
        segementControl.addTarget(self, action: #selector(self.segmentDidClick(sender:)), for: .valueChanged)
    }
    
    @objc private func segmentDidClick(sender: UISegmentedControl){
        currentSegment(index: sender.selectedSegmentIndex)
    }
}

extension DiscoverViewController{
    fileprivate func setUpChildViewController(){
        addChildViewController(nearByViewController)
        addChildViewController(routeViewController)
        
        currentViewController(index: 0)
    }
    
    fileprivate func currentSegment(index: Int){
        segementControl.selectedSegmentIndex = index
        scrollView.setContentOffset(CGPoint(x: CGFloat(index) * scrollView.bounds.width, y: 0), animated: true)
        currentViewController(index: index)
    }
    
    fileprivate func currentViewController(index: Int){
        let x = CGFloat(index) * UIScreen.main.bounds.width
        let w = scrollView.bounds.width
        let h = scrollView.bounds.height
        switch index {
        case 0:
            let nearBy = childViewControllers[0] as! NearbyViewController
            if nearBy.view.superview != nil {return}
            nearBy.view.frame = CGRect(x: x, y: 0, width: w, height: h)
            scrollView.addSubview(nearBy.view)
        default:
            let routeVc = childViewControllers[1] as! RouteViewController
            newRoutes = 0
            segementControl.setTitle("行程", forSegmentAt: 1)
            routeVc.routeInfos = routeInfos
            if routeVc.view.superview != nil {return}
            routeVc.view.frame = CGRect(x: x, y: 0, width: w, height: h)
            scrollView.addSubview(routeVc.view)
        }
    }
}

extension DiscoverViewController{
    fileprivate func setUpNote(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.addRoute(note:)), name: NSNotification.Name(rawValue: "AddRouteNote"), object: nil)
    }
    
    @objc private func addRoute(note: Notification){
        let info = note.userInfo?["info"] as! BMKPoiInfo
        routeInfos.append(info)
        newRoutes += 1
        segementControl.setTitle("行程(\(newRoutes))", forSegmentAt: 1)
        
    }
}
