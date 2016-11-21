//
//  SearchAnimator.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/21.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class SearchAnimator: NSObject, UIViewControllerTransitioningDelegate{
    fileprivate var isPresented: Bool = false
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

extension SearchAnimator: UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? presentedAnimation(transitionContext: transitionContext) : dismissAnimation(transitionContext: transitionContext)
    }
}

extension SearchAnimator{
    fileprivate func presentedAnimation(transitionContext: UIViewControllerContextTransitioning){
        let toView = transitionContext.view(forKey: .to)
        let containerView = transitionContext.containerView
//        containerView.frame = UIScreen.main.bounds
        containerView.addSubview(toView!)
        toView?.alpha = 0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            toView?.alpha = 1
            }) { (_) in
                transitionContext.completeTransition(true)
        }
    }
    
    fileprivate func dismissAnimation(transitionContext: UIViewControllerContextTransitioning){
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        let containerView = transitionContext.containerView
//        containerView.frame = UIScreen.main.bounds
        if toView != nil{
            containerView.addSubview(toView!)
        }
        containerView.addSubview(fromView!)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            fromView?.alpha = 0
            }) { (_) in
                transitionContext.completeTransition(true)
        }
    }

}
