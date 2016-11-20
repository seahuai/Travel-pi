//
//  DrawerPresentationController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/20.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

let menuWidth = UIScreen.main.bounds.width * 0.8

class DrawerPresentationController: UIPresentationController {

    fileprivate lazy var coverView = UIView()
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        let screenB = UIScreen.main.bounds
        presentedView?.frame = CGRect(x: 0, y: 0, width: menuWidth, height: screenB.height)
        coverView.frame = containerView!.bounds
        coverView.backgroundColor = UIColor(white: 0.2, alpha: 0.2)
        containerView?.insertSubview(coverView, at: 0)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.coverViewTap))
        coverView.addGestureRecognizer(tapGes)
    }
    
    @objc private func coverViewTap(){
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
}
