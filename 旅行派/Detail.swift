//
//  Detail.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/25.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class Detail: NSObject {
    
    static let shared: Detail = Detail()
    
    override init() {
        super.init()
    }
    
    var plans: [Plan] = [Plan]()
}
