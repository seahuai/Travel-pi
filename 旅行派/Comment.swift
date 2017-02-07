//
//  Comment.swift
//  旅行派
//
//  Created by 张思槐 on 17/1/26.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit

class Comment: NSObject {
    var from: String?
    var to: String?
    var content: String = ""
    
    init(from: String, to: String?, content: String){
        self.from = from
        self.to = to
        self.content = content
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
