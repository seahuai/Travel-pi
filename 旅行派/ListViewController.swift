//
//  ListViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/25.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var destination: Destination?{
        didSet{
            oldDestination = oldValue
        }
    }
    fileprivate var initial: Bool = true
    fileprivate var oldDestination: Destination?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if oldDestination == nil || initial || destination!.name! != oldDestination!.name!{
            tableView.reloadData()
        }
    }
}


extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    fileprivate func setUpTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Detail.shared.targets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.orange
        return cell
    }
}
