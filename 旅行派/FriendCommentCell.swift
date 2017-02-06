//
//  FriendCommentCell.swift
//  旅行派
//
//  Created by 张思槐 on 17/1/26.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit

class FriendCommentCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    
    var comment: Comment?{
        didSet{
            var str = ""
            var isReply:Bool = false
            let from = comment?.from
            let to = comment?.to
            let content = comment?.content
            if to == nil{
                str = "\(from!):\(content!)"
                isReply = false
            }else{
                str = "\(from!)回复\(to!):\(content!)"
                isReply = true
            }
            convertText(from: from!, to: to, text: str, isReply: isReply, spaceLength: 2)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

extension FriendCommentCell{
    fileprivate func convertText(from: String, to: String?, text: String, isReply: Bool, spaceLength: Int){
        
        let attStr = NSMutableAttributedString(string: text)
        
        //改变字体颜色方法
        if isReply{
            let fromLength = stringLength(text: from)
            let toLength = stringLength(text: to!)
            let fromRange = NSRange(location: 0, length: fromLength)
            let toRange = NSRange(location: fromLength + spaceLength, length: toLength)
            
            attStr.addAttribute(NSForegroundColorAttributeName, value: globalColor, range: fromRange)
            attStr.addAttribute(NSForegroundColorAttributeName, value: globalColor, range: toRange)
        }else{
            let index = text.range(of: ":")!.lowerBound
            let length = stringLength(text: text.substring(to: index))
            let range = NSRange(location: 0, length: length)
            attStr.addAttribute(NSForegroundColorAttributeName, value: globalColor, range: range)
        }
        
        commentLabel.attributedText = attStr
    }
    
    private func stringLength(text: String) -> Int{
        return Int(Double(text.lengthOfBytes(using: .unicode)) * 0.5)
    }
}
