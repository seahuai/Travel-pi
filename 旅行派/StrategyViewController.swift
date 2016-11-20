//
//  StrategyViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/6.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

protocol StrategyTableViewDelegate {
    func strategyTableView(offset: CGFloat)
}


class StrategyViewController: UIViewController {

    var delegate: StrategyTableViewDelegate?
    
    //MARK:折叠tableView相关属性
    fileprivate var headerViewTitle = ["景点1","景点2","景点3"]
    fileprivate var sectionSelected: [Bool] = [Bool](repeatElement(true, count: 3))
    
    
    var destination: Destination?{
        didSet{
            guard destination != nil else {return}
            if destination!.name == "当前位置"{
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setUpTableView()
    }
}
extension StrategyViewController{
    fileprivate func setUpTableView(){
        tableView.separatorStyle = .none
        tableView.register(StrategyHeaderView.self, forHeaderFooterViewReuseIdentifier: "StrategyHeaderView")
    }
}


extension StrategyViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerViewTitle.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "StrategyHeaderView") as! StrategyHeaderView
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.headerViewSelected(sender:)))
        view.tag = section
        view.gestureRecognizers?.removeAll()
        view.addGestureRecognizer(tapGes)
        view.text = headerViewTitle[section]
        view.selected = sectionSelected[section]
        return view
    }
    
    @objc private func headerViewSelected(sender: UITapGestureRecognizer){
        let tag = sender.view!.tag
        sectionSelected[tag] = !sectionSelected[tag]
        tableView.reloadSections([tag], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionSelected[section] ? 10 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let distance: CGFloat = 100
        delegate?.strategyTableView(offset: offset - distance)
    }
    
}
