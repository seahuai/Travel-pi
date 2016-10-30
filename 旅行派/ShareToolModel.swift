//
//  ShareToolBar.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/30.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class ShareToolModel: NSObject {
    
    static let sharedInstance: ShareToolModel = ShareToolModel()
    
    var models: [ShareToolModel] = [ShareToolModel]()
    
    var name: String?
    var district_id: Int = 0
    
    init(name: String, district_id: Int) {
        super.init()
        self.name = name
        self.district_id = district_id
        models.append(self)
    }
    
    override init() {
        super.init()
    }
}
