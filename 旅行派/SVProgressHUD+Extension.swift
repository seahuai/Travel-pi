//
//  SVProgressHUD+Extension.swift
//  旅行派
//
//  Created by 张思槐 on 17/2/8.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit
import SVProgressHUD
extension SVProgressHUD{
    class func showError(error: String, interval: TimeInterval){
        SVProgressHUD.setFadeInAnimationDuration(0)
        SVProgressHUD.showError(withStatus: error)
        SVProgressHUD.dismiss(withDelay: interval)
    }
    
    class func showInfo(info: String, interval: TimeInterval){
        SVProgressHUD.setFadeInAnimationDuration(0)
        SVProgressHUD.showInfo(withStatus: info)
        SVProgressHUD.dismiss(withDelay: interval)
    }
    
    class func showSuccess(info: String, interval: TimeInterval){
        SVProgressHUD.setFadeInAnimationDuration(0)
        SVProgressHUD.showSuccess(withStatus: info)
        SVProgressHUD.dismiss(withDelay: interval)
    }
}
