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
//    fileprivate var cellMaxY: CGFloat = 0
    var isResign: Bool = true
    var currentCommentRow: Int = 0
    fileprivate var models: [FriendCircle] = [FriendCircle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //模拟网络请求
        getFriendCircle()
        
        setUp()
        setUpNavigationBar()
        setUpTableView()
        setUpKeyBoardNotefication()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
}


extension FriendsCircleViewController{
    fileprivate func setUp(){
        automaticallyAdjustsScrollViewInsets = false
        backgroundOriginalHeight = backgroundViewHeightCon.constant
//        originalPoint = CGPoint(x: 0, y: -backgroundOriginalHeight + 64)
    }
    
    fileprivate func setUpNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: nil)
        navigationController?.navigationBar.barStyle = .black
        
        titleLabel.textColor = UIColor.white
        titleLabel.alpha = 0
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: 8)
        titleLabel.text = "分享"
        navigationItem.titleView = titleLabel
        titleLabel.sizeToFit()
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isResign {commentTextField.resignFirstResponder()}
        foldBackgroundImageView()
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

//MARK: 评论代理
extension FriendsCircleViewController: commentDelegate{
    func comment(to: String, maxY: CGFloat, row: Int) {
        currentCommentRow = row
        commentTextField.becomeFirstResponder()
        commentTextField.placeholder = "回复:\(to)"
    }
    
    //MARK:发送评论
    @IBAction func sendCommentButtonClick(_ sender: AnyObject) {
        let user = Account.shared.currentUserID
        let text = commentTextField.text
        if text == nil { SVProgressHUD.showInfo(withStatus: "评论不能为空"); SVProgressHUD.dismiss(withDelay: 0.5) ;return}
        let comment = Comment(from: user!, to: nil, content: text!)
        print("commenth: \(comment.cellHeight)")
        models[currentCommentRow].comments.append(comment)
        models[currentCommentRow].cellHeight += comment.cellHeight
        commentTextField.resignFirstResponder()
        commentTextField.text = nil
        tableView.reloadRows(at: [IndexPath(row: currentCommentRow, section: 0)], with: .none)
    }
}

//MARK: 键盘的弹出
extension FriendsCircleViewController{
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
    
    private func downloadImage(models: [FriendCircle]){
        
        let group = DispatchGroup()
        
        for model in models{
            for url in model.imgUrls{
                group.enter()
                SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (_, error, _, _, _) in
                    if error != nil {print("网络情况不佳")}
                    group.leave()
                })
               
            }
        }
        group.notify(queue: DispatchQueue.main) { 
            self.tableView.reloadData()
        }
    }

}



