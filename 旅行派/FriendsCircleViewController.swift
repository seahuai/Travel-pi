//
//  FriendsCircleViewController.swift
//  旅行派
//
//  Created by 张思槐 on 17/1/26.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
class FriendsCircleViewController: UIViewController {
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentTextFieldBottomCon: NSLayoutConstraint!
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundViewHeightCon: NSLayoutConstraint!
    //属性
    fileprivate var backgroundOriginalHeight: CGFloat = 0
    fileprivate var originalPoint: CGPoint = CGPoint()
    fileprivate lazy var titleLabel = UILabel()
    var currentCommentRow: Int = 0
    var to: String?
    fileprivate var models: [FriendCircle] = [FriendCircle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //模拟网络请求
        getFriendCircle()
        
        setUp()
        setUpNavigationBar()
        setUpTableView()
        setUpKeyBoardNotefication()
        setUpCommentNotification()
        setUpSelectImageNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if EMClient.shared().isLoggedIn{
            headImageView.isHidden = false
            headImageView.image = UIImage(named: "avator")
            nameLabel.text = EMClient.shared().currentUsername
        }else{
            headImageView.isHidden = true
            nameLabel.text = "尚未登录"
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
}


extension FriendsCircleViewController{
    fileprivate func setUp(){
        automaticallyAdjustsScrollViewInsets = false
        backgroundOriginalHeight = backgroundViewHeightCon.constant
        headImageView.image = UIImage(named: "avator")
    }
    
    fileprivate func setUpNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.presentComVC))
        navigationController?.navigationBar.barStyle = .black
        
        titleLabel.textColor = UIColor.white
        titleLabel.alpha = 0
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: 8)
        titleLabel.text = "分享"
        navigationItem.titleView = titleLabel
        titleLabel.sizeToFit()
    }
    
    @objc private func presentComVC(){
        if !EMClient.shared().isLoggedIn {
            let loginAlert = UIAlertController(title: "登录后才可发布动态", message: "前往登录？", preferredStyle: .alert)
            let cancelAc = UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
                loginAlert.dismiss(animated: true, completion: nil)
            })
            let loginAc = UIAlertAction(title: "登录", style: .default, handler: { (_) in
                let nav = UINavigationController(rootViewController: LoginViewController())
                loginAlert.dismiss(animated: true, completion: nil)
                self.present(nav, animated: true, completion: nil)
            })
            loginAlert.addAction(loginAc)
            loginAlert.addAction(cancelAc)
            present(loginAlert, animated: true, completion: nil)
            return
        }
        let composeVc = ComposeViewController()
        //MARK:实现发送界面的代理
        composeVc.delegate = self
        let nav = UINavigationController(rootViewController: composeVc)
        present(nav, animated: true, completion: nil)
    }
    
}
//MARK:发送界面代理回调
extension FriendsCircleViewController: ComposeDelegate{
    func compose(imageUrls: [URL], content: String?) {
        let user = Account.shared.currentUserID
        let avotor = "http://img.jiqie.com/10/8/1370nz.jpg"
        let model = FriendCircle(user: user!, avaterUrl: avotor, urls: imageUrls, text: content ?? "")
        models = [model] + models
        
        downloadImage(models: models)
        
        SVProgressHUD.showInfo(info: "发送成功", interval: 0.5)
    }
}

extension FriendsCircleViewController: UITableViewDataSource, UITableViewDelegate{
    fileprivate func setUpTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: backgroundViewHeightCon.constant - 64, left: 0, bottom: 0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .singleLineEtched
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return models[indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCircleCell", for: indexPath) as! FriendCircleCell
        cell.commentDelegate = self
        cell.row = indexPath.row
        cell.friendCircleModel = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shVc = SHPhotoBrowserViewController(imgUrls: models[indexPath.row].imgUrls, indexPath: IndexPath(item: 0, section: 0))
        shVc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(shVc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        foldBackgroundImageView()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        commentTextField.resignFirstResponder()
    }

    fileprivate func foldBackgroundImageView(){
        let minusY = -backgroundOriginalHeight + 64
        let Y = -minusY
        let offset: CGFloat = tableView.contentOffset.y - minusY
        var height = backgroundOriginalHeight - offset
        if(height < 64){
            height = 64
        }
        backgroundViewHeightCon.constant = height
        let alpha: CGFloat = (Y - offset) / Y
        headImageView.alpha = alpha
        nameLabel.alpha = alpha
        titleLabel.alpha = 1 - alpha
    }
}

extension FriendsCircleViewController{
    fileprivate func setUpSelectImageNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushSHVc(note:)), name:  NSNotification.Name(rawValue: "SelectImageNote"), object: nil)
    }
    
    @objc private func pushSHVc(note: NSNotification){
        let indexPath = note.userInfo?["indexPath"] as! IndexPath
        let urls = note.userInfo?["imgUrls"] as! [URL]
        let shVc = SHPhotoBrowserViewController(imgUrls: urls, indexPath: indexPath)
        shVc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(shVc, animated: true)
    }
}

//MARK: 评论代理
extension FriendsCircleViewController: commentDelegate{
    func comment(to: String, maxY: CGFloat, row: Int) {
        currentCommentRow = row
        commentTextField.becomeFirstResponder()
        commentTextField.placeholder = "回复:\(to)"
        tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .none, animated: false)
        tableView.contentOffset.y += commentTextFieldBottomCon.constant
        
    }
    
    //MARK: 回复评论方法
    fileprivate func setUpCommentNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.replyComment(note:)), name: NSNotification.Name(rawValue: "ReplyCommentNote"), object: nil)
    }
    
    @objc private func replyComment(note: NSNotification){
        let com = note.userInfo?["comment"] as! Comment
        let row = note.userInfo?["row"] as! Int
        self.to = com.from
        comment(to: self.to!, maxY: 0, row: row)
    }
    
    //MARK:发送评论
    @IBAction func sendCommentButtonClick(_ sender: AnyObject) {
        let user = Account.shared.currentUserID
        let text = commentTextField.text
        if !EMClient.shared().isLoggedIn || user == nil{
            SVProgressHUD.showError(error: "您尚未登录", interval: 0.5)
            return
        }
        if (text!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).lengthOfBytes(using: .utf8) == 0){
            SVProgressHUD.showError(error: "评论不能为空", interval: 0.5)
            return
        }
        
        sendComment(from: user!, to: to, text: text!)
        self.to = nil
        
        tableView.reloadRows(at: [IndexPath(row: currentCommentRow, section: 0)], with: .none)
    }
    
    fileprivate func sendComment(from: String, to: String?, text: String){
        let comment = Comment(from: from, to: to, content: text)
        print("commenth: \(comment.cellHeight)")
        models[currentCommentRow].comments.append(comment)
        models[currentCommentRow].cellHeight += comment.cellHeight
        commentTextField.resignFirstResponder()
        commentTextField.text = nil
    }
    
    
}

//MARK: 键盘的弹出
extension FriendsCircleViewController{
    @IBAction func resignButtonClick(_ sender: AnyObject) {
        commentTextField.resignFirstResponder()
    }
    
    fileprivate func setUpKeyBoardNotefication(){
        NotificationCenter.default.addObserver(self, selector: #selector(changeTextFieldPositon(note:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    @objc private func changeTextFieldPositon(note: Notification){
        let interval = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let endFrame = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = UIScreen.main.bounds.height - endFrame.origin.y
        commentTextFieldBottomCon.constant = y
        UIView.animate(withDuration: interval, animations: {
            self.view.layoutIfNeeded()
        })
    }
}



//MARK:模拟从网络中获取数据
extension FriendsCircleViewController{
    fileprivate func getFriendCircle(){
        let path = Bundle.main.path(forResource: "CircleModel", ofType: "plist")
        let arr = NSArray(contentsOfFile: path!)
        for a in arr!{
            let dict = a as! [String: AnyObject]
            let model = FriendCircle(dict: dict)
            self.models.append(model)
        }
        
        downloadImage(models: models)
    }
    
    fileprivate func downloadImage(models: [FriendCircle]){
        
        let group = DispatchGroup()
        
        for model in models{
            for url in model.imgUrls{
                group.enter()
                SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (_, error, _, _, _) in
                    if error != nil {SVProgressHUD.showError(error: "网络情况不佳", interval: 1)}
                    group.leave()
                })
               
            }
        }
        group.notify(queue: DispatchQueue.main) { 
            self.tableView.reloadData()
        }
    }

}



