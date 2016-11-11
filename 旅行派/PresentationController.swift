//
//  PresentationController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/11.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    fileprivate lazy var coverView = UIView()
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        let screenBounds = UIScreen.main.bounds
        let width = screenBounds.width * 0.8
        let height = screenBounds.height * 0.6
        presentedView?.frame = CGRect(x: 0, y: 64, width: width, height: height)
        presentedView?.layer.cornerRadius = 20
//        presentedView?.layer.masksToBounds = true
        coverView.frame = containerView!.bounds
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.3)
        containerView?.insertSubview(coverView, at: 0)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.tapCoverView))
        coverView.addGestureRecognizer(tapGes)
    }
    
    @objc private func tapCoverView(){
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
