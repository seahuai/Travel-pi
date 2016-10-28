//
//  FindMoreVCAnimator.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/28.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class FindMoreVCAnimator: NSObject, UIViewControllerTransitioningDelegate {
    
    fileprivate var isPresented: Bool = false
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
}


extension FindMoreVCAnimator: UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? presentAnimation(transitionContext: transitionContext) : dismissAnimation(transitionContext: transitionContext)
    }
}

//MARK:具体动画实现
extension FindMoreVCAnimator{
    fileprivate func presentAnimation(transitionContext: UIViewControllerContextTransitioning){
        
    }
    
    fileprivate func dismissAnimation(transitionContext: UIViewControllerContextTransitioning){
        
    }
}
