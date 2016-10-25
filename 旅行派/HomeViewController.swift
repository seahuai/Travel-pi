//
//  HomeViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/25.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var destinationTableView: UITableView!
    @IBOutlet weak var displayScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        setUpNavigationBar()
        setUpTableView()
        setUpScrollView()
        
    }
}


extension HomeViewController{
    fileprivate func setUpNavigationBar(){
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    fileprivate func setUpTableView(){
        destinationTableView.delegate = self
        destinationTableView.dataSource = self
    }
    
    fileprivate func setUpScrollView(){
        displayScrollView.delegate = self
    }
}

//MARK:tableView-DataSource-Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.darkGray
        return cell
    }
}

//MARK:scrollView-Delegate
extension HomeViewController: UIScrollViewDelegate{
    
}
