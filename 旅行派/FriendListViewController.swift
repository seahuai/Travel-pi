//
//  FriendListViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/12/2.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import SVProgressHUD

class FriendListViewController: UITableViewController {

    static let list: FriendListViewController = FriendListViewController()
    fileprivate var contacts: [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.mj_header.beginRefreshing()
    }
}

extension FriendListViewController{
    
    fileprivate func setUpNavigationBar(){
        navigationItem.title = "好友列表"
        let rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addFriend))
        navigationItem.rightBarButtonItem = rightItem
        let leftItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(self.close))
        navigationItem.leftBarButtonItem = leftItem
    }
    
    @objc private func close(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func addFriend(){
        
        let ac = UIAlertController(title: "发送好友申请", message: "", preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "对方用户id"
        }
        ac.addTextField { (textField) in
            textField.placeholder = "理由"
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
            ac.dismiss(animated: true, completion: nil)
        }
        let sendAction = UIAlertAction(title: "发送", style: .default) { (_) in
            let username = ac.textFields?.first?.text
            let reason = ac.textFields?.last?.text
            let error = EMClient.shared().contactManager.addContact(username, message: reason)
            SVProgressHUD.show(withStatus: "发送中")
            if error == nil{
                SVProgressHUD.showSuccess(withStatus: "发送成功")
                SVProgressHUD.dismiss(withDelay: 0.5)
            }else{
                SVProgressHUD.showError(withStatus: error!.errorDescription)
                SVProgressHUD.dismiss(withDelay: 1.0)
            }
            ac.dismiss(animated: true, completion: nil)
        }
        
        ac.addAction(cancelAction)
        ac.addAction(sendAction)
        present(ac, animated: true, completion: nil)
    }
    
    fileprivate func setUp(){
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refreshFriendList))
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.setTitle("下拉加载好友列表", for: .idle)
        header?.setTitle("松开刷新", for: .pulling)
        header?.setTitle("加载中", for: .refreshing)
        tableView.mj_header = header
        tableView.register(UINib(nibName: "FriendRequestCell", bundle: nil), forCellReuseIdentifier: "FriendRequestCell")
//        hidesBottomBarWhenPushed = true
        title = "好友列表"
        modalPresentationStyle = .custom
    }
    
    @objc private func refreshFriendList(){
        EMClient.shared().contactManager.getContactsFromServer { (contacts, error) in
            if error == nil{
                if contacts != nil{
                    self.contacts = contacts as! [String]
                }
                self.tableView.reloadData()
            }else{
                print(error!.errorDescription)
                
            }
            self.tableView.mj_header.endRefreshing()
        }
    }
}

extension FriendListViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return Account.shared.friendRequests.count
        }else{
            return contacts.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell", for: indexPath) as! FriendRequestCell
            cell.request = Account.shared.friendRequests[indexPath.row]
            cell.delegate = self
            cell.indexPath = indexPath
            return cell
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell")
            if cell == nil{
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "FriendCell")
            }
            cell?.textLabel?.text = contacts[indexPath.row]
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 85
        }
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            let id = contacts[indexPath.row]
            let chatVc = ChatViewController()
            chatVc.conversationId = id
            chatVc.hidesBottomBarWhenPushed = true
//            let nav = UINavigationController(rootViewController: chatVc)
            navigationController?.pushViewController(chatVc, animated: true)
        }
    }
}


extension FriendListViewController: FriendRequestCellDelegate{
    func handleRequest(agree: Bool, index: Int?) {
        if index != nil{
            Account.shared.friendRequests.remove(at: index!)
            tableView.deleteRows(at: [IndexPath(row: index!, section: 0)], with: .left)
        }
    }
}



