//
//  MessageViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/12/2.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class MessageViewController: UITableViewController {

    
    @IBOutlet weak var leftBarButtonClick: UIBarButtonItem!
    
    fileprivate var conversations: [EMConversation] = [EMConversation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        conversations = EMClient.shared().chatManager.getAllConversations() as! [EMConversation]
        tableView.reloadData()
//        refresh()
    }
    

    @IBAction func leftBarButtonClick(_ sender: AnyObject) {
        present(ProfileViewController.shared, animated: true, completion: nil)
    }
    
    @IBAction func startNewConversation(_ sender: AnyObject) {
        let nav = UINavigationController(rootViewController: FriendListViewController.list)
        present(nav, animated: true, completion: nil)
    }

    
}

extension MessageViewController{
    
    fileprivate func setUp(){
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refreshConversation))
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("获取回话...", for: .refreshing)
        header?.setTitle("松开刷新", for: .pulling)
        tableView.mj_header = header
    }
    
    @objc fileprivate func refreshConversation(){
        conversations = EMClient.shared().chatManager.getAllConversations() as! [EMConversation]
        endRefresh()
    }
    
    fileprivate func refresh(){
        tableView.mj_header.beginRefreshing()
    }
    
    fileprivate func endRefresh(){
        tableView.mj_header.endRefreshing()
        tableView.reloadData()
    }
    
}

extension MessageViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
        cell.conversation = conversations[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVc = ChatViewController()
        chatVc.hidesBottomBarWhenPushed = true
        chatVc.conversationId = conversations[indexPath.row].conversationId
        navigationController?.pushViewController(chatVc, animated: true)
    }
}



