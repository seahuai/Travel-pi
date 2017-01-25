//
//  DiscoverViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/6.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    fileprivate var destination: Destination?
    fileprivate var isBarHidden: Bool = false
    
    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var searchBarTopCon: NSLayoutConstraint!
//    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nearByButton: UIButton!
    @IBOutlet weak var strategyButton: UIButton!
    
    fileprivate lazy var popAnimator: PopAnimator = PopAnimator()
    
    //MARK:控制器
    fileprivate lazy var nearByVC: NearbyViewController = NearbyViewController()
//    fileprivate lazy var strategyVC: StrategyViewController = StrategyViewController()
    fileprivate lazy var cityListVC: CityListViewController = CityListViewController()
    fileprivate var currentVC: UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpChildViewController()
        setUpScrollView()
        setUpButton()
        setUpCityListVC()
        setUpNotification()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension DiscoverViewController{
    fileprivate func setUpNotification(){
        //监听来自CityCell的通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.getNotification(note:)), name: NSNotification.Name(rawValue: "ChangeCityNote"), object: nil)
    }
    
    @objc private func getNotification(note: Notification){
//        let des = note.userInfo!["destination"] as! Destination
        let cityName = note.userInfo!["cityName"] as! String
        let coordinate = note.userInfo!["coordinate"] as! CLLocationCoordinate2D
        if cityName == "无法获取"
        {
            let alertController = UIAlertController(title: "无法定位到当前位置", message: "请打开定位服务后重试", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default) { (_) in
                alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            dismiss(animated: true) {
                self.present(alertController, animated: true, completion: nil)
            }
            return
        }
        let alertController = UIAlertController(title: "切换至", message: "\"\(cityName)\"", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default) { (_) in
            self.nearByVC.coordinate = coordinate
        }
        let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (_) in}
        alertController.addAction(okAction)
        alertController.addAction(cancleAction)
        dismiss(animated: true) {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}


extension DiscoverViewController{
    
    fileprivate func setUpChildViewController(){
        addChildViewController(nearByVC)
//        addChildViewController(strategyVC)
//        strategyVC.view.frame = scrollView.bounds
//        strategyVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.width, y: 0)
        
        currentVC = nearByVC
        nearByVC.view.frame = scrollView.bounds
        nearByVC.view.frame.origin = CGPoint(x: 0, y: 0)
        scrollView.addSubview(nearByVC.view)
//        scrollView.addSubview(strategyVC.view)
        
    }
    
    fileprivate func setUpScrollView(){
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    fileprivate func setUpButton(){
        nearByButton.isSelected = true
    }
    
    fileprivate func setUpCityListVC(){
        cityListVC.modalPresentationStyle = .custom
        cityListVC.transitioningDelegate = popAnimator
    }
}

//MARK:按钮的监听
extension DiscoverViewController{
    @IBAction func searchButtonClick(_ sender: UIBarButtonItem) {
        present(SearchViewController.shared, animated: true, completion: nil)
    }
    
    @IBAction func toolViewButtonClick(_ sender: UIButton) {
        
        if (sender.tag == 1 && currentVC == nearByVC){
            return
        }
        
        if sender.tag == 1{
            sender.isSelected = true
            strategyButton.isSelected = false
            transition(from: currentVC!, to: nearByVC, duration: 0.5, options: .curveEaseInOut, animations: {
//                    self.scrollView.contentOffset.x = 0
                }, completion: { (_) in
                self.currentVC = self.nearByVC
                    self.scrollView.contentOffset.x = 0
            })
        }
        
//        if sender.tag == 2{
//            sender.isSelected = true
//            nearByButton.isSelected = false
//            transition(from: currentVC!, to: strategyVC, duration: 0.5, options: .curveEaseInOut, animations: {
////                    self.scrollView.contentOffset.x = UIScreen.main.bounds.width
//                }, completion: { (_) in
//                self.currentVC = self.strategyVC
//                    self.scrollView.contentOffset.x = UIScreen.main.bounds.width
//            })
//        }
        strategyButton.backgroundColor = !strategyButton.isSelected ? UIColor.groupTableViewBackground : UIColor.clear
        nearByButton.backgroundColor = !nearByButton.isSelected ? UIColor.groupTableViewBackground : UIColor.clear
    }
    
    @IBAction func switchCityButtonClick(_ sender: UIBarButtonItem) {
        present(cityListVC, animated: true, completion: nil)
    }
    
}

