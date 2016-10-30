//
//  ShareViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/25.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    @IBOutlet weak var shareTableView: UITableView!

    var toolBarModels: [String] = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }


}


extension ShareViewController{
    fileprivate func setUpTableView(){
        shareTableView.delegate = self
        shareTableView.dataSource = self
        shareTableView.separatorStyle = .none
    }
}


extension ShareViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShareCell", for: indexPath)
        
        cell.selectionStyle = .none
        return cell
    }
    
    
}

