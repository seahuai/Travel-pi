//
//  PhotoBrowserAnimator.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/2.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

protocol PhotoBrowserPresentedDelegate {
    func getImageView(item: Int, isMain: Bool) -> UIImageView
    func getStartRect(item: Int, isMain: Bool) -> CGRect
    func getEndRecrt(item: Int, isMain: Bool) -> CGRect
}

protocol PhotoBrowserDismissDelegate {
    func getCellIndexPath() -> IndexPath
    func getImageView() -> UIImageView
}

class PhotoBrowserAnimator: NSObject, UIViewControllerTransitioningDelegate {

    var isPresented: Bool = false
    var dismissDelegate: PhotoBrowserDismissDelegate?
    var presentedDelegate: PhotoBrowserPresentedDelegate? 
    var item = 0
    var isMain: Bool = false
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
    
}

extension PhotoBrowserAnimator: UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? presentedAnimation(transitionContext: transitionContext) : dismissAnimation(transitionContext: transitionContext)
    }
    
}

extension PhotoBrowserAnimator{
    fileprivate func presentedAnimation(transitionContext: UIViewControllerContextTransitioning){
        let containerView = transitionContext.containerView
        let toVC = transitionContext.viewController(forKey: .to) as! PhotoBrowserViewController
        let blackView = UIView(frame: containerView.bounds)
        blackView.backgroundColor = UIColor.black
        containerView.addSubview(blackView)
        containerView.addSubview(toVC.view)
        toVC.view.alpha = 0
        let tempImage: UIImageView = presentedDelegate!.getImageView(item: item, isMain: isMain)
        let endRect = presentedDelegate!.getEndRecrt(item: item, isMain: isMain)
        tempImage.frame = presentedDelegate!.getStartRect(item: item, isMain: isMain)
        containerView.addSubview(tempImage)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            tempImage.frame = endRect
            
            }) { (_) in
                tempImage.removeFromSuperview()
                toVC.view.alpha = 1
                blackView.removeFromSuperview()
                transitionContext.completeTransition(true)
        }
    }
    
    fileprivate func dismissAnimation(transitionContext: UIViewControllerContextTransitioning){
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        let containerView = transitionContext.containerView
        containerView.addSubview(toView!)
        containerView.addSubview(fromView!)
        fromView?.alpha = 1
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            fromView?.alpha = 0
            }) { (_) in
                transitionContext.completeTransition(true)
                fromView?.removeFromSuperview()
        }
    
    }
    
//    
//    fileprivate func dismissAnimation(transitionContext: UIViewControllerContextTransitioning){
//        let fromView = transitionContext.view(forKey: .from)
//        let containerView = transitionContext.containerView
//        containerView.backgroundColor = UIColor.clear
//        containerView.addSubview(fromView!)
//        let indexPath = dismissDelegate!.getCellIndexPath()
//        let tempImage = dismissDelegate?.getImageView()
//        tempImage?.frame = presentedDelegate!.getEndRecrt(item: indexPath.item - 1, isMain: indexPath.item == 0)
//        containerView.addSubview(tempImage!)
//        let endRect = presentedDelegate!.getStartRect(item: indexPath.item - 1, isMain: indexPath.item == 0)
//        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
//            tempImage?.frame = endRect
//            fromView?.alpha = 0
//            print(endRect)
//            }) { (_) in
//                transitionContext.completeTransition(true)
//                tempImage?.removeFromSuperview()
//                fromView?.removeFromSuperview()
//        }
//        
//    }
}
