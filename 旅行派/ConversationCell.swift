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
    
    

    var conversation: EMConversation?{
        didSet{
            usernameLabel.text = conversation?.conversationId
            if let lastMes = conversation?.latestMessage{
                lastMessageLabel.text = (lastMes.body as! EMTextMessageBody).text
                timeLabel.attributedText = JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: Date(timeIntervalSince1970: TimeInterval(lastMes.timestamp/1000)))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
