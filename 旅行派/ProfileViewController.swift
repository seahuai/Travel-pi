//
//  ProfileViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/31.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    static let shared: ProfileViewController = ProfileViewController()
    
    fileprivate lazy var animator = DrawerAnimator()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.transitioningDelegate = animator
        self.modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @IBAction func dismissButtonClick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        print("viewDidLoad")
    }

}

extension ProfileViewController{
    fileprivate func setUp(){
        let swipe = UISwipeGestureRecognizer(target: self, action:#selector(self.swipeView))
        swipe.direction = .left
        view.addGestureRecognizer(swipe)
    }
    
    @objc fileprivate func swipeView(){
        dismiss(animated: true, completion: nil)
    }
}
