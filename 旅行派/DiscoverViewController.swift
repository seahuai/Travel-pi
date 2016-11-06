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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var searchBarTopCon: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var nearByButton: UIButton!
    @IBOutlet weak var strategyButton: UIButton!
    
    //MARK:控制器
    fileprivate lazy var nearByVC: NearbyViewController = NearbyViewController()
    fileprivate lazy var strategyVC: StrategyViewController = StrategyViewController()
    fileprivate lazy var searchDetailVC: SearchDetailViewController = SearchDetailViewController()
    fileprivate var currentVC: UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        setUpChildViewController()
        setUpScrollView()
        setUpButton()
    }
    
}

extension DiscoverViewController{
    
    fileprivate func setUpChildViewController(){
        addChildViewController(nearByVC)
        addChildViewController(strategyVC)
        strategyVC.view.frame = scrollView.bounds
        strategyVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.width, y: 0)
        scrollView.addSubview(strategyVC.view)
        
        currentVC = nearByVC
        nearByVC.view.frame = scrollView.bounds
        nearByVC.view.frame.origin = CGPoint(x: 0, y: 0)
        scrollView.addSubview(nearByVC.view)
        
    }
    
    fileprivate func setUpScrollView(){
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    fileprivate func setUpButton(){
        nearByButton.isSelected = true
    }
}

//MARK:按钮的监听
extension DiscoverViewController{
    @IBAction func searchButtonClick(_ sender: UIBarButtonItem) {
        if searchBarTopCon.constant < 0{
            searchBar.becomeFirstResponder()
            UIView.animate(withDuration: 0.3, animations: {
                self.searchBarTopCon.constant = 0
                self.view.layoutIfNeeded()
                self.scrollView.contentOffset.x = self.currentVC == self.strategyVC ? UIScreen.main.bounds.width : 0
                })

        }else
        if searchBarTopCon.constant == 0 {
            searchBar.resignFirstResponder()
            UIView.animate(withDuration: 0.3, animations: {
                self.searchBarTopCon.constant = -40
                self.view.layoutIfNeeded()
                self.scrollView.contentOffset.x = self.currentVC == self.strategyVC ? UIScreen.main.bounds.width : 0
                })
        }
    }
    
    @IBAction func toolViewButtonClick(_ sender: UIButton) {
        
        if (sender.tag == 1 && currentVC == nearByVC) || (sender.tag == 2 && currentVC == strategyVC){
            return
        }
        
        if sender.tag == 1{
            sender.isSelected = true
            strategyButton.isSelected = false
            transition(from: currentVC!, to: nearByVC, duration: 0.5, options: .curveEaseInOut, animations: {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
                
                }, completion: { (_) in
                self.currentVC = self.nearByVC
            })
        }
        
        if sender.tag == 2{
            sender.isSelected = true
            nearByButton.isSelected = false
            transition(from: currentVC!, to: strategyVC, duration: 0.5, options: .curveEaseInOut, animations: {
                    self.scrollView.contentOffset = CGPoint(x: UIScreen.main.bounds.width, y: 0)
                
                }, completion: { (_) in
                self.currentVC = self.strategyVC
            })
        }
        
        strategyButton.backgroundColor = !strategyButton.isSelected ? UIColor.groupTableViewBackground : UIColor.clear
        nearByButton.backgroundColor = !nearByButton.isSelected ? UIColor.groupTableViewBackground : UIColor.clear
    }
    
}



extension DiscoverViewController: UISearchBarDelegate{
    fileprivate func setUpSearchBar(){
        searchBar.placeholder = "输入你的目的地"
        searchBar.showsCancelButton = true
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
//        let text = searchBar.text
        searchDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchDetailVC, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            self.searchBarTopCon.constant = -40
            self.view.layoutIfNeeded()
            self.scrollView.contentOffset.x = self.currentVC == self.strategyVC ? UIScreen.main.bounds.width : 0
        })
    }
    
    
}


