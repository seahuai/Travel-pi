//
//  ConversationCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/12/3.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

//用它的时间工具
import JSQMessagesViewController

class ConversationCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var unreadMessageCountLabel: UILabel!

    var conversation: EMConversation?{
        didSet{
            usernameLabel.text = conversation?.conversationId
            let count = conversation!.unreadMessagesCount
            if count != 0{
                unreadMessageCountLabel.text = String(count)
                unreadMessageCountLabel.isHidden = false
            }else{
                unreadMessageCountLabel.isHidden = true
            }
            if let lastMes = conversation?.latestMessage{
                switch lastMes.body {
                case is EMTextMessageBody:
                    lastMessageLabel.text = (lastMes.body as! EMTextMessageBody).text
                case is EMLocationMessageBody:
                    lastMessageLabel.text = "[位置]"
                case is EMImageMessageBody:
                    lastMessageLabel.text = "[图片]"
                default:
                    break;
                }
                timeLabel.attributedText = JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: Date(timeIntervalSince1970: TimeInterval(lastMes.timestamp/1000)))
            }else{
                lastMessageLabel.text = "暂无消息"
                timeLabel.attributedText = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        unreadMessageCountLabel.layer.cornerRadius = 10
        unreadMessageCountLabel.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
