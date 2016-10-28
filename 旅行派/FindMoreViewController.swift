//
//  FindMoreViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/28.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class FindMoreViewController: UIViewController {
    
    @IBOutlet weak var FindMoreTableView: UITableView!
    var destinations: [Destination] = [Destination]()
    fileprivate lazy var animator: FindMoreVCAnimator = FindMoreVCAnimator()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpNavigationBar()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FindMoreTableView.reloadData()
    }

}


extension FindMoreViewController{
    
    fileprivate func setUp(){
        self.modalPresentationStyle = .custom
        let swipeGes = UISwipeGestureRecognizer(target: self, action: #selector(self.back))
        swipeGes.direction = .right
        view.addGestureRecognizer(swipeGes)
    }
    
    fileprivate func setUpNavigationBar(){
        let leftBarButton = UIBarButtonItem(title: "<-返回", style: .plain, target: self, action: #selector(self.back))
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    fileprivate func setUpTableView(){
        FindMoreTableView.dataSource = self
        FindMoreTableView.delegate = self
        FindMoreTableView.register(UINib(nibName: "FindMoreCell", bundle: nil), forCellReuseIdentifier: "FindMoreCell")
        FindMoreTableView.separatorStyle = .none
    }
    
    @objc private func back(){
        dismiss(animated: true) {}
    }
}

extension FindMoreViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(destinations.count)
        return destinations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FindMoreCell", for: indexPath) as! FindMoreCell
        cell.destination = destinations[indexPath.row]
        cell.selectionStyle = .none
        cell.layoutIfNeeded()
        return cell
    }
    
    
}


