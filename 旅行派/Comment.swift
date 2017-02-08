//
//  Comment.swift
//  旅行派
//
//  Created by 张思槐 on 17/1/26.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit

class Comment: NSObject {
    var from: String?
    var to: String?
    var content: String = ""{
        didSet{
            cellHeight = getCellHeight(text: content)
        }
    }
    var cellHeight: CGFloat = 0
    init(from: String, to: String?, content: String){
        super.init()
        self.from = from
        self.to = to
        self.content = content
        let text = to == nil ? content + "\(from)回复:" : content + "\(from)回复\(to):"
        self.cellHeight = getCellHeight(text: text)
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    fileprivate func getCellHeight(text: String) -> CGFloat{
        let str = text as NSString
        let attr = [NSFontAttributeName : UIFont.systemFont(ofSize: 13)]
        let rect = str.boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 65, height: CGFloat(MAXFLOAT)), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: attr, context: nil)
        return rect.height
    }
}


