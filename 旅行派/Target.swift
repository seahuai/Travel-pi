//
//  Target.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/26.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class Target: NSObject {
    var id: Int = 0
//    var _descripation:
    var title: String?
    var summary: String?
    var photo_url: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
