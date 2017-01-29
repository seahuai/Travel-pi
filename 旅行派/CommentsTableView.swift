//
//  CommentsTableView.swift
//  旅行派
//
//  Created by 张思槐 on 17/1/29.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit

class CommentsTableView: UITableView {

    var comments: [Comment] = [Comment](){
        didSet{
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isScrollEnabled = false
        separatorStyle = .none
        delegate = self
        dataSource = self
        register(UINib(nibName: "FriendCommentCell", bundle: nil), forCellReuseIdentifier: "FriendCommentCell")
    }

}

extension CommentsTableView: UITableViewDataSource, UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return commentH
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCommentCell", for: indexPath) as! FriendCommentCell
        cell.comment = comments[indexPath.row]
        return cell
    }
}
