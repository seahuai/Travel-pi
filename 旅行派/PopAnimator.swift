//
//  CityListAnimator.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/11.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerTransitioningDelegate {
    
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

extension PopAnimator: UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    @objc(presentationControllerForPresentedViewController:presentingViewController:sourceViewController:) func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? presentedAnimation(transitionContext: transitionContext) : dismissAnimation(transitionContext: transitionContext)
    }
    
    fileprivate func presentedAnimation(transitionContext: UIViewControllerContextTransitioning){
        let toView = transitionContext.view(forKey: .to)
        let containerView = transitionContext.containerView
        containerView.addSubview(toView!)
        toView?.alpha = 0
        toView?.transform = CGAffineTransform(scaleX: 1.0, y: 0)
        toView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            toView?.alpha = 0.9
            }) { (_) in
                transitionContext.completeTransition(true)
        }
    }
    
    fileprivate func dismissAnimation(transitionContext: UIViewControllerContextTransitioning){
        let fromView = transitionContext.view(forKey: .from)
        let containerView = transitionContext.containerView
        containerView.addSubview(fromView!)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            containerView.alpha = 0
            }) { (_) in
                fromView?.removeFromSuperview()
                transitionContext.completeTransition(true)
        }
    }
    
    
    
    
    
    
    
}
