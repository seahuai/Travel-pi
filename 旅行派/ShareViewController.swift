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
    @IBOutlet weak var toolScrollView: UIScrollView!
    var toolBarModels: [ShareToolModel] = [ShareToolModel]()
    
    var notes: [TravelNote] = [TravelNote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        getTravelNotes()
    }


}


extension ShareViewController{
    fileprivate func setUpTableView(){
        shareTableView.delegate = self
        shareTableView.dataSource = self
        shareTableView.separatorStyle = .none
        
        shareTableView.rowHeight = 500
    }
}


extension ShareViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShareCell", for: indexPath) as! ShareCell
        cell.note = notes[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
}

extension ShareViewController{
    
    fileprivate func getTravelNotes(){
        NetWorkTool.sharedInstance.getTravelNotes() { (error, result) in
            if error != nil{print(error); return}
            if let result = result{
                for dict in result{
                    let note = TravelNote(dict: dict["activity"] as! [String: AnyObject])
                    self.notes.append(note)
                }
            }
            self.shareTableView.reloadData()
        }
        
    }
    
    
    
}

