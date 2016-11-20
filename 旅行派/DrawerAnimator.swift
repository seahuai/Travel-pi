//
//  FindMoreVCAnimator.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/28.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class DrawerAnimator: NSObject, UIViewControllerTransitioningDelegate {
    
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


extension DrawerAnimator: UIViewControllerAnimatedTransitioning{
    
    @objc(presentationControllerForPresentedViewController:presentingViewController:sourceViewController:) func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? presentAnimation(transitionContext: transitionContext) : dismissAnimation(transitionContext: transitionContext)
    }
}

//MARK:具体动画实现
extension DrawerAnimator{

    
    fileprivate func presentAnimation(transitionContext: UIViewControllerContextTransitioning){
        let toView = transitionContext.view(forKey: .to)
        let containerView = transitionContext.containerView
        toView?.frame.origin = CGPoint(x: -menuWidth, y: 0)
        containerView.addSubview(toView!)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView?.frame.origin = CGPoint(x: 0, y: 0)
            }) { (_) in
                transitionContext.completeTransition(true)
        }
    }
    
    fileprivate func dismissAnimation(transitionContext: UIViewControllerContextTransitioning){
        let fromView = transitionContext.view(forKey: .from)
        let containerView = transitionContext.containerView
        containerView.addSubview(fromView!)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            fromView?.frame.origin = CGPoint(x: -menuWidth, y: 0)
            }) { (_) in
                fromView?.removeFromSuperview()
                transitionContext.completeTransition(true)
        }
    }
}
