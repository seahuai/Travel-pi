//
//  ProfileViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/31.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    //WARN:不能通过监听变量的方式刷新tableView，因为tableView还有可能未创建！！
//    var newMessage: Bool = false
//    var newRequest: Bool = false
    
    fileprivate lazy var logoutView = LogoutView.creat()
    fileprivate var isLogin: Bool = EMisLogin{
        didSet{
            logoutView.isHidden = isLogin
        }
    }
    
    static let shared: ProfileViewController = ProfileViewController()
    
    fileprivate lazy var animator = DrawerAnimator()
    fileprivate let function1: [String] = ["消息"]
    fileprivate let function2: [String] = ["好友列表","好友申请"]
    fileprivate let function3: [String] = ["退出"]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.transitioningDelegate = animator
        self.modalPresentationStyle = .custom
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logoutView.frame = view.bounds
        view.addSubview(logoutView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpLogoutView()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.text = Account.shared.currentUserID
        if Account.shared.newMessage{
            tableView.reloadSections([0], with: .none)
        }
        if Account.shared.newRequest{
            tableView.reloadSections([1], with: .none)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension ProfileViewController{
    fileprivate func setUp(){
        let swipe = UISwipeGestureRecognizer(target: self, action:#selector(self.swipeView))
        swipe.direction = .left
        view.addGestureRecognizer(swipe)
        logoutView.isHidden = isLogin
        EMClient.shared().add(self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loginSuccess), name: NSNotification.Name(rawValue: "LoginSussess"), object: nil)
    }
    
    @objc fileprivate func swipeView(){
        dismiss(animated: true, completion: nil)
    }
}


//MARK:访客视图相关方法
extension ProfileViewController: EMClientDelegate{
    fileprivate func setUpLogoutView(){
        logoutView.goToLoginButton.addTarget(self, action: #selector(self.goToLoginButtonClick), for: .touchUpInside)
    }
    
    @objc fileprivate func loginSuccess(){
        isLogin = true
    }
    
    @objc private func goToLoginButtonClick(){
        let nav = UINavigationController(rootViewController: LoginViewController())
        nav.modalPresentationStyle = .custom
        present(nav, animated: true, completion: nil)
    }
    
    fileprivate func loadProfileView(){
        super.loadView()
    }
    
    func userAccountDidLoginFromOtherDevice() {
        print("账号被登出")
        isLogin = false
    }
    
    func userAccountDidRemoveFromServer() {
        isLogin = false
    }
    
}

//MARK: 数据源和代理
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate{
    fileprivate func setUpTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "FunctionCell", bundle: nil), forCellReuseIdentifier: "FunctionCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return function1.count
        case 1:
            return function2.count
        case 2:
            return function3.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FunctionCell", for: indexPath) as! FunctionCell
        switch indexPath.section {
        case 0:
            cell.functionLabel.text = function1[indexPath.row]
            cell.badge.isHidden = !Account.shared.newMessage
            cell.isExit = false
        case 1:
            cell.functionLabel.text = function2[indexPath.row]
            cell.isExit = false
            if indexPath.row == 1{
                cell.badge.isHidden = !Account.shared.newRequest
            }
        default:
            cell.functionLabel.text = function3[indexPath.row]
            cell.isExit = true
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            dismiss(animated: true, completion: { 
                let tabVc = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
                tabVc.selectedIndex = 3
                Account.shared.newMessage = false
            })
            
        }
        
        if indexPath.section == 1{
            let nav = UINavigationController(rootViewController: FriendListViewController.list)
            nav.modalPresentationStyle = .custom
            present(nav, animated: true, completion: nil)
        }
        
        if indexPath.section == 2{
            logout()
        }
    }
    
    fileprivate func logout(){
        let ac = UIAlertController(title: "确定要退出当前账号吗", message: nil, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "确定", style: .destructive, handler: { (_) in
            let error = EMClient.shared().logout(false)
            if error == nil{
                SVProgressHUD.showSuccess(withStatus: "成功登出")
                self.isLogin = false
            }else{
                SVProgressHUD.showError(withStatus: error!.errorDescription)
            }
            SVProgressHUD.dismiss(withDelay: 0.8)
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
            ac.dismiss(animated: true, completion: nil)
        })
        
        ac.addAction(logoutAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true, completion: nil)
    }
    
    
}
