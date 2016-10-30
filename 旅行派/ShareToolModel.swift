//
//  ShareToolBar.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/30.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class ShareToolModel: NSObject {
        
    var name: String?
    var district_id: Int = 0
    
    init(name: String?, district_id: Int) {
        super.init()
        self.name = name
        self.district_id = district_id
    }
    
    override init() {
        super.init()
    }
    
    override var description: String{
        return dictionaryWithValues(forKeys: ["name", "district_id"]).description
    }
}
