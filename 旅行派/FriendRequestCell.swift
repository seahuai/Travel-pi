//
//  FriendRequestCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/12/3.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

protocol FriendRequestCellDelegate {
    func handleRequest(agree: Bool, index: Int?)
}

class FriendRequestCell: UITableViewCell {
    
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var agreeButton: UIButton!
    var delegate: FriendRequestCellDelegate?
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    var indexPath: IndexPath?
    var request: friendRequest?{
        didSet{
            usernameLabel.text = "用户名" + request!.userId
            if let reason = request?.reason{
                reasonLabel.text = "理由:\(reason)"
            }else{
                reasonLabel.text = "理由:无"
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    @IBAction func agreeButtonClick(_ sender: AnyObject) {
        EMClient.shared().contactManager.acceptInvitation(forUsername: request?.userId)
        delegate?.handleRequest(agree: true, index: indexPath?.row)
    }
    
    @IBAction func rejectButtonClcik(_ sender: AnyObject) {
        EMClient.shared().contactManager.declineInvitation(forUsername: request?.userId)
        delegate?.handleRequest(agree: false, index: indexPath?.row)
    }
    
    private func setUp(){
        rejectButton.layer.cornerRadius = 15
        agreeButton.layer.cornerRadius = 15
        rejectButton.layer.masksToBounds = true
        agreeButton.layer.masksToBounds = true
    }
    
}
