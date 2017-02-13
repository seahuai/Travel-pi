//
//  RouteModel.swift
//  旅行派
//
//  Created by 张思槐 on 17/2/13.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit

class RouteModel: NSObject {
    var cellHeight: CGFloat = 75
    var name: String?
    var address: String?
    var phone: String?
    var isNew:Bool = true
    var index: Int = -1
    init(info: BMKPoiInfo, index: Int) {
        name = info.name
        address = info.address
        phone = info.phone
        self.index = index
    }
}
