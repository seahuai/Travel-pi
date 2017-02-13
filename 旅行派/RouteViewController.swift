//
//  RouteViewController.swift
//  旅行派
//
//  Created by 张思槐 on 17/2/10.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit

class RouteViewController: UIViewController {
    
    //api: http://api.map.baidu.com/direction
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        tableView.reloadData()
    }
    
    func reload(){
        if tableView != nil{
            tableView.reloadData()
        }
    }
}



extension RouteViewController: UITableViewDelegate, UITableViewDataSource, RouteCellDelegate{
    fileprivate func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RouteCell", bundle: nil), forCellReuseIdentifier: "RouteCell")
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Route.shared.cellHeight(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Route.shared.routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as! RouteCell
        cell.info = Route.shared.routes[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Route.shared.routes[indexPath.row].cellHeight = Route.shared.routes[indexPath.row].cellHeight == 75 ? 115 : 75
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "删除") { (_ ,_) in
            let index = Route.shared.routes[indexPath.row].index
            if let i = Route.shared.routesIndex.index(of: index) {
                Route.shared.routesIndex.remove(at: i)
            }
            Route.shared.routes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
        return [delete]
    }
    
    func goWalk() {
        
    }
    
    func byCar() {
        
    }
    
    func byBus() {
        
    }
}
