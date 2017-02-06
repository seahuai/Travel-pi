//
//  FriendsCircleViewController.swift
//  旅行派
//
//  Created by 张思槐 on 17/1/26.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit
import SDWebImage
class FriendsCircleViewController: UIViewController {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundViewHeightCon: NSLayoutConstraint!
    //属性
    fileprivate var backgroundOriginalHeight: CGFloat = 0
    fileprivate var originalPoint: CGPoint = CGPoint()
    fileprivate lazy var titleLabel = UILabel()
    
    fileprivate var models: [FriendCircle] = [FriendCircle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //模拟网络请求
        getFriendCircle()
        
        setUp()
        setUpNavigationBar()
        setUpTableView()
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
        cell.friendCircleModel = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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



