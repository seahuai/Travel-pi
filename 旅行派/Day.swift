//
//  Day.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/25.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class Day: NSObject {
    var id: Int = 0
    var plan_id: Int = 0
    var _description: String?
    var activities: [Activity] = [Activity]()
    var activityConunt: Int = 0
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
        _description = dict["description"] as? String
        for point in dict["points"] as! [[String: AnyObject]]{
            let acDict = point["inspiration_activity"] as! [String: AnyObject]
            let activity = Activity(dict: acDict)
            activities.append(activity)
            activityConunt += 1
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
