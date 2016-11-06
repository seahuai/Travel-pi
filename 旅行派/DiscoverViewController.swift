//
//  DiscoverViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/6.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    
    @IBOutlet weak var searchBarTopCon: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var nearByButton: UIButton!
    @IBOutlet weak var strategyButton: UIButton!
    
    //MARK:控制器
    fileprivate lazy var nearByVC: NearbyViewController = NearbyViewController()
    fileprivate lazy var strategyVC: StrategyViewController = StrategyViewController()
    fileprivate var currentVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        setUpChildViewController()
        setUpButton()
    }
    
}

extension DiscoverViewController{
    
    fileprivate func setUpChildViewController(){
        addChildViewController(nearByVC)
        addChildViewController(strategyVC)
        strategyVC.view.frame = view.bounds
        strategyVC.view.frame.origin = CGPoint(x: 0, y: 104)
        
        currentVC = nearByVC
        nearByVC.view.frame = view.bounds
        nearByVC.view.frame.origin = CGPoint(x: 0, y: 104)
        view.addSubview(nearByVC.view)
        
    }
    
    fileprivate func setUpSearchBar(){
        
    }
    
    fileprivate func setUpButton(){
        nearByButton.isSelected = true
    }
}

//MARK:按钮的监听
extension DiscoverViewController{
    @IBAction func searchButtonClick(_ sender: UIBarButtonItem) {
        if searchBarTopCon.constant < 0{
            UIView.animate(withDuration: 0.3, animations: {
                self.currentVC?.view.frame.origin.y += 40
                self.searchBarTopCon.constant = 0
                self.view.layoutIfNeeded()
            })
        }else if searchBarTopCon.constant == 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.currentVC?.view.frame.origin.y -= 40
                self.searchBarTopCon.constant = -40
                self.view.layoutIfNeeded()
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
            transition(from: currentVC!, to: nearByVC, duration: 1.0, options: .curveEaseInOut, animations: {
                
                
                }, completion: { (_) in
                self.currentVC = self.nearByVC
            })
        }
        
        if sender.tag == 2{
            sender.isSelected = true
            nearByButton.isSelected = false
            transition(from: currentVC!, to: strategyVC, duration: 1.0, options: .curveEaseInOut, animations: nil, completion: { (_) in
                self.currentVC = self.strategyVC
            })
        }
        
        strategyButton.backgroundColor = strategyButton.isSelected ? UIColor.groupTableViewBackground : UIColor.clear
        nearByButton.backgroundColor = nearByButton.isSelected ? UIColor.groupTableViewBackground : UIColor.clear
    }
    
    
    
}
