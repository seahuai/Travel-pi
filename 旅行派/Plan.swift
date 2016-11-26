//
//  Plan.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/25.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class Plan: NSObject {
    
    var id: Int = 0
    var photo_id: Int? = 0
    var title: String?
    var days_count: Int = 0
    var photo_url: String?
    var _days: [Day] = [Day]()
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
        let photo = dict["photo"] as? [String: AnyObject]
        photo_url = photo?["url"] as? String
        let dayArr = dict["days"] as! [[String: AnyObject]]
        for day_dict in dayArr{
            let day = Day(dict: day_dict)
            _days.append(day)
        }
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
