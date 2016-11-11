//
//  Destination.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/24.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class Destination: NSObject {

    var id: Int = 0
    var district_id: Int = -1
    var lat: CLLocationDegrees = -1
    var lng: CLLocationDegrees = -1
    var name: String?
    var name_en: String?
    var photo_url: String?
    var _description: String?
    var tip: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
        
        _description = dict["description"] as? String
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
