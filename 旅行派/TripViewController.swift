//
//  TripViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/25.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class TripViewController: UIViewController {
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var name_enLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    fileprivate var oldDestination: Destination?
    fileprivate var initial: Bool = true
    fileprivate lazy var tripDetailVc: TripDetailViewController = TripDetailViewController()
    var destination: Destination?{
        didSet{
            oldDestination = oldValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        setUp()
        setUpTableView()
        setUpTableViewRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if initial || (oldDestination!.name! != destination!.name!) {
            tableView.contentOffset.y = 0
//            print("reloadTrip")
//            getDetailPlan(id: destination!.id)
            tableView.mj_header.beginRefreshing()
            if let urlStr = destination?.photo_url{
               let url = URL(string: urlStr)
                topImageView.sd_setImage(with: url)
            }
            nameLabel.text = destination?.name
            name_enLabel.text = destination?.name_en
            tableView.contentOffset.y = 0
        }
    }
}

extension TripViewController{
    
    fileprivate func setUp(){
        automaticallyAdjustsScrollViewInsets = false
    }
    
    fileprivate func setUpTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "PlanCell", bundle: nil), forCellReuseIdentifier: "PlanCell")
        tableView.register(UINib(nibName: "TargetCell", bundle: nil), forCellReuseIdentifier: "TargetCell")
    }
    
    fileprivate func setUpTableViewRefresh(){
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refreshTableView))
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放刷新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
    }
    
    @objc private func refreshTableView(){
        getDetailPlan(id: destination!.id)
    }
    
    
}

extension TripViewController : UITableViewDataSource, UITableViewDelegate{
    
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 1{return "剪影"}
//        return nil
//    }
//    
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        print(Detail.shared.targets.count)
        if Detail.shared.targets.count != 0 {return 2}
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{return 400}
        return 200
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{return Detail.shared.plans.count}
        else {return Detail.shared.targets.count}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath) as! PlanCell
            cell.plan = Detail.shared.plans[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TargetCell", for: indexPath) as! TargetCell
            cell.targetModel = Detail.shared.targets[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            tripDetailVc.days = Detail.shared.plans[indexPath.row]._days
            self.navigationController?.pushViewController(tripDetailVc, animated: true)
        }
        
    }
}

extension TripViewController{
    
    fileprivate func getDetailPlan(id: Int){
        NetWorkTool.sharedInstance.getDestinationInformation(id: id) { (error, result) in
            if error != nil {print("获取数据失败");return}
            let sections = result!["sections"] as! [[String: AnyObject]]
//            Detail.shared.plans.removeAll()
//            Detail.shared.plans.removeAll()
            Detail.shared.removeDetail()
            for section in sections{
                let type = section["type"] as! String
                let models = section["models"] as! [[String: AnyObject]]
                if type == "Plan"{
                    for model in models{
                        let plan = Plan(dict: model)
                        Detail.shared.plans.append(plan)
                    }
                }
                if type == "ActivityCollection"{
                    for model in models{
                        let target = Target(dict: model)
                        Detail.shared.targets.append(target)
                    }
                }
                self.tableView.reloadData()
                self.initial = false
                self.tableView.mj_header.endRefreshing()
            }
        }
    }
}












