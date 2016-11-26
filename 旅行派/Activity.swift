//
//  Activity.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/25.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class Activity: NSObject {
    //详细攻略id
    var id: Int = 0
    var visit_tip: String?
    var address: String?
    var topic: String?
    var introduce: String?
    var photo_url: String?
    var collections_id: [Int] = [Int]()
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
        let photo = dict["photo"] as! [String: AnyObject]
        photo_url = photo["photo_url"] as? String
        let collections = dict["activity_collections"] as! [[String: AnyObject]]
        for collection in collections{
            let c_id = collection["id"] as! Int
            collections_id.append(c_id)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
