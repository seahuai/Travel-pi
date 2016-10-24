//
//  Content.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/23.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class Content: NSObject {
    
    //照片描述
    var caption: String?
    var photo_url: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
//        caption = dict["caption"] as? String
//        photo_url = dict["photo_url"] as? String
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
