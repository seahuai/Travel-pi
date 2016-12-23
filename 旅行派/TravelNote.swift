//
//  TravelNote.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/23.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class TravelNote: NSObject {

    //shareCell相关
    var cellHeight: CGFloat = 500
    var labelHeight: CGFloat = 80
    var isFold: Bool = false
    
    var _user: User?
    
    var id: Int = 0
    //2016-10-20T01:47:42.000Z
    var made_at: String?{
        didSet{
            let strings = made_at?.components(separatedBy: "T")
            made_date = strings?[0]
            made_time = (strings?.last?.components(separatedBy: "Z"))?.first
        }
    }
    var made_date: String?
    var made_time: String?
    
    var topic: String?
    var _description: String?//*
    var district_id: Int?
    var districts: [String?] = [String?]()
    
    var _contents: [Content] = [Content]()
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
        if topic == nil{
            topic = "详情"
        }
        _description = dict["description"] as? String

        if let districts = dict["districts"] as? [[String: AnyObject]]{
            for dict in districts{
                let name = dict["name"] as? String
                self.districts.append(name)
            }
        }
        
        if let contents = dict["contents"] as? [[String: AnyObject]]{
            for dict in contents{
                let content: Content = Content(dict: dict)
                _contents.append(content)
            }
        }
        
        if let user = dict["user"] as? [String: AnyObject]{
            _user = User(dict: user)
        }
        
    }

    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    
    override var description: String{
        return dictionaryWithValues(forKeys: ["topic", "_description"]).description
    }
    
}
