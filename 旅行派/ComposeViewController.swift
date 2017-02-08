//
//  ComposeViewController.swift
//  旅行派
//
//  Created by 张思槐 on 17/2/8.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    fileprivate lazy var titleView = ComposeTitleView(frame: CGRect(x: 0, y: 0, width: 120, height: 44))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
    }

}

extension ComposeViewController{
    fileprivate func setUpNavigationBar(){
        let closeButton = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(self.close))
        let composeButton = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(self.compose))
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = composeButton
        navigationItem.titleView = titleView
        titleView.sizeToFit()
    }
    
    @objc private func close(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func compose(){
        
    }
}
