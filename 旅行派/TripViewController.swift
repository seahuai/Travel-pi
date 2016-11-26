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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if initial || (oldDestination!.name! != destination!.name!) {
            getDetailPlan(id: destination!.id)
            if let urlStr = destination?.photo_url{
               let url = URL(string: urlStr)
                topImageView.sd_setImage(with: url)
            }
            nameLabel.text = destination?.name
            name_enLabel.text = destination?.name_en
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
    }
}

extension TripViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Detail.shared.plans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath) as! PlanCell
        cell.plan = Detail.shared.plans[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tripDetailVc.days = Detail.shared.plans[indexPath.row]._days
        self.navigationController?.pushViewController(tripDetailVc, animated: true)
        
    }
}

extension TripViewController{
    
    fileprivate func getDetailPlan(id: Int){
        NetWorkTool.sharedInstance.getDestinationInformation(id: id) { (error, result) in
            if error != nil {print("获取数据失败");return}
            let sections = result!["sections"] as! [[String: AnyObject]]
            for section in sections{
                let type = section["type"] as! String
                let models = section["models"] as! [[String: AnyObject]]
                if type == "Plan"{
                    Detail.shared.plans.removeAll()
                    for model in models{
                        let plan = Plan(dict: model)
                        Detail.shared.plans.append(plan)
                    }
                    self.tableView.reloadData()
                    self.initial = false
                    print("reloadData")
                }
            }
        }
    }
}












