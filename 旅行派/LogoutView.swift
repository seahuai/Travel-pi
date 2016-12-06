//
//  LogOutView.swift
//  旅行派
//
//  Created by 张思槐 on 16/12/2.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class LogoutView: UIView {

    @IBOutlet weak var goToLoginButton: UIButton!
    class func creat() -> LogoutView{
        let view = Bundle.main.loadNibNamed("LogoutView", owner: nil, options: nil)?.first as! LogoutView
        return view
    }

}
