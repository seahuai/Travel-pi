//
//  TravelAlbum.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/23.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class TravelAlbum: NSObject {

    var travelNotes: [TravelNote?] = [TravelNote?]()
    var summary: String?

    init(dict: [String: AnyObject]) {
        summary = dict["summary"] as? String
        if let notes = dict["items"] as? [[String: AnyObject]] {
            for note in notes{
                if let user_activity = note["user_activity"] as? [String: AnyObject]{
                    travelNotes.append(TravelNote(dict: user_activity))
                }
            }
        }
    }
    
    
    override var description: String{
        return dictionaryWithValues(forKeys: ["summary"]).description
    }
    
    
}
