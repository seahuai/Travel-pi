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
    
    fileprivate lazy var detailVC: DetailViewController = DetailViewController()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        FindMoreTableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}


extension FindMoreViewController{
    
   
    
    fileprivate func setUpNavigationBar(){
//        let leftBarButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.back))
//        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: nil, action: nil)
    }
    
    fileprivate func setUpTableView(){
        FindMoreTableView.dataSource = self
        FindMoreTableView.delegate = self
        FindMoreTableView.register(UINib(nibName: "FindMoreCell", bundle: nil), forCellReuseIdentifier: "FindMoreCell")
        FindMoreTableView.separatorStyle = .none
    }
    

}

extension FindMoreViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FindMoreCell", for: indexPath) as! FindMoreCell
        cell.destination = destinations[indexPath.row]
        cell.selectionStyle = .none
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailVC.destination = destinations[indexPath.row]
        detailVC.isPresented = false
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    
}


