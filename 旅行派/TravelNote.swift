//
//  TravelNote.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/23.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class TravelNote: NSObject {

    var _user: User?
    
    var id: Int = 0
    //2016-10-20T01:47:42.000Z
    var made_at: String?
    var made_date: NSDate?
    var made_time: NSDate?
    
    var topic: String?
    var _description: String?//*
    var district_id: Int?
    var districts: [String?] = [String?]()
    
    var _contents: [Content] = [Content]()
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
        
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
