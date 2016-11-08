//
//  NearbyViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/6.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

protocol NearByTableViewDelegate {
    func nearByTableView(offset: CGFloat)
}

class NearbyViewController: UIViewController {

    //代理属性
    var delegate: NearByTableViewDelegate?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }

}

extension NearbyViewController{
    func setUpTableView(){
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension NearbyViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.section)-\(indexPath.row))"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let distance: CGFloat = 100
        delegate?.nearByTableView(offset: offset - distance)
    }
    
    
}
