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
    //一个垃圾效果
//    fileprivate func presentAnimation(transitionContext: UIViewControllerContextTransitioning){
//        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
//        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
//        let containerView = transitionContext.containerView
//        
//        let tempView = fromView?.snapshotView(afterScreenUpdates: false)
//        tempView?.bounds = fromView!.bounds
//        tempView?.layer.position = fromView!.frame.origin
//        tempView?.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
//        tempView?.frame.origin = CGPoint(x: 0, y: 0)
//        
//        let fromShadow = UIView()
//        fromShadow.frame = tempView!.bounds
//        fromShadow.backgroundColor = UIColor.black
//        fromShadow.alpha = 0
//        
//        let toShadow = UIView()
//        toShadow.frame = toView!.bounds
//        toShadow.backgroundColor = UIColor.black
//        toShadow.alpha = 1
//        toView?.addSubview(toShadow)
//        
//        tempView?.addSubview(fromShadow)
//        containerView.addSubview(toView!)
//        
//        containerView.addSubview(tempView!)
//        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
//            tempView?.layer.transform = CATransform3DMakeRotation(CGFloat(-M_PI_2), 0, 1, 0)
//            fromShadow.alpha = 0.5
//            toShadow.alpha = 0
//            }) { (_) in
//                tempView?.removeFromSuperview()
//                toShadow.removeFromSuperview()
//                transitionContext.completeTransition(true)
//        }
//    }
    
    fileprivate func presentAnimation(transitionContext: UIViewControllerContextTransitioning){
        let toView = transitionContext.view(forKey: .to)
        let containerView = transitionContext.containerView
        containerView.addSubview(toView!)

        toView?.frame.origin = CGPoint(x: UIScreen.main.bounds.width, y: 0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView?.frame.origin = CGPoint(x: 0, y: 0)
            }) { (_) in
                transitionContext.completeTransition(true)
        }
    }
    
    fileprivate func dismissAnimation(transitionContext: UIViewControllerContextTransitioning){
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        let containerView = transitionContext.containerView
        containerView.addSubview(toView!)
        containerView.addSubview(fromView!)
        
        toView?.alpha = 0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            fromView?.frame.origin = CGPoint(x: UIScreen.main.bounds.width, y: 0)
            toView?.alpha = 1
            }) { (_) in
                fromView?.removeFromSuperview()
                transitionContext.completeTransition(true)
        }
    }
}
