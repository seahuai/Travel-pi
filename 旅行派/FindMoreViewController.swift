//
//  FindMoreViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/28.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class FindMoreViewController: UIViewController {

    var destinations: [Destination] = [Destination]()

    fileprivate lazy var animator: FindMoreVCAnimator = FindMoreVCAnimator()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpNavigationBar()
    }

}


extension FindMoreViewController{
    
    fileprivate func setUp(){
        self.modalPresentationStyle = .custom
        transitioningDelegate = animator
    }
    
    fileprivate func setUpNavigationBar(){
        let leftBarButton = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(self.back))
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc private func back(){
        dismiss(animated: true) {}
    }
}


