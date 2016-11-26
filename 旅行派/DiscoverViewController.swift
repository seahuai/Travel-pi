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
    fileprivate lazy var strategyVC: StrategyViewController = StrategyViewController()
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
        let alertController = UIAlertController(title: "将当前城市切换为", message: "\(cityName)", preferredStyle: .alert)
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
        addChildViewController(strategyVC)
        strategyVC.view.frame = scrollView.bounds
        strategyVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.width, y: 0)
        
        currentVC = nearByVC
        nearByVC.view.frame = scrollView.bounds
        nearByVC.view.frame.origin = CGPoint(x: 0, y: 0)
        scrollView.addSubview(nearByVC.view)
        scrollView.addSubview(strategyVC.view)
        
        nearByVC.delegate = self
        strategyVC.delegate = self
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
        
        if (sender.tag == 1 && currentVC == nearByVC) || (sender.tag == 2 && currentVC == strategyVC){
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
        
        if sender.tag == 2{
            sender.isSelected = true
            nearByButton.isSelected = false
            transition(from: currentVC!, to: strategyVC, duration: 0.5, options: .curveEaseInOut, animations: {
//                    self.scrollView.contentOffset.x = UIScreen.main.bounds.width
                }, completion: { (_) in
                self.currentVC = self.strategyVC
                    self.scrollView.contentOffset.x = UIScreen.main.bounds.width
            })
        }
        strategyButton.backgroundColor = !strategyButton.isSelected ? UIColor.groupTableViewBackground : UIColor.clear
        nearByButton.backgroundColor = !nearByButton.isSelected ? UIColor.groupTableViewBackground : UIColor.clear
    }
    
    @IBAction func switchCityButtonClick(_ sender: UIBarButtonItem) {
        present(cityListVC, animated: true, completion: nil)
    }
    
}



//MARK:子控制器的代理
extension DiscoverViewController: NearByTableViewDelegate, StrategyTableViewDelegate{
    
    fileprivate func hideTabBar(isHidden: Bool){
        let y: CGFloat = isHidden ? UIScreen.main.bounds.height + 49 : UIScreen.main.bounds.height - 49
        UIView.animate(withDuration: 0.5) {
            self.tabBarController?.tabBar.frame.origin.y = y
        }
    }
    
    
    func naerByTableView(upOrNot: Bool) {
        hideTabBar(isHidden: upOrNot)
    }
    
    func nearByTableView(offset: CGFloat) {

    }
    
    func strategyTableView(offset: CGFloat) {

    }
    
    private func handleNavigationBar(offset: CGFloat){
        scrollView.contentOffset.x = self.currentVC == self.strategyVC ? UIScreen.main.bounds.width : 0

        var h = offset < 0 ? 44 : 44 - offset
        if h < 0 {
            h = 0
            isBarHidden = true
            navigationController?.navigationBar.alpha = 0
        }else{
            isBarHidden = false
            navigationController?.navigationBar.alpha = 1
        }
        navigationController?.navigationBar.bounds.size.height = h
    }
}


