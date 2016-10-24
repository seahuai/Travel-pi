//
//  User.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/23.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var photo_url: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
//        
//        name = dict["name"] as? String
//        photo_url = dict["photo_url"] as? String
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
