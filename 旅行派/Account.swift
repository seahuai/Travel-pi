//
//  Account.swift
//  旅行派
//
//  Created by 张思槐 on 16/12/2.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

struct friendRequest {
    var userId: String
    var reason: String?
}

class Account: NSObject {

    static let shared: Account = Account()
    var friendRequests: [friendRequest] = [friendRequest]()
    var currentUserID: String? = EMClient.shared().currentUsername
    var newMessage:Bool = false
    var newRequest: Bool = false
}
