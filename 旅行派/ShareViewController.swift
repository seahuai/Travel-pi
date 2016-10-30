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
    
    //记录展开全文的行号
    fileprivate var row: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        getTravelNotes()
        setUpNotification()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension ShareViewController{
    fileprivate func setUpTableView(){
        shareTableView.delegate = self
        shareTableView.dataSource = self
        shareTableView.separatorStyle = .none
        shareTableView.estimatedRowHeight = 500
    }
    
    fileprivate func setUpNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadCellHeight(note:)), name: NSNotification.Name(rawValue: "unfoldNote"), object: nil)
    }
    
    @objc private func reloadCellHeight(note: Notification){
        row = note.userInfo!["row"] as! Int
        notes[row].cellHeight = note.userInfo!["cellHeight"] as! CGFloat
        notes[row].labelHeight = note.userInfo!["LabelHeight"] as! CGFloat
        notes[row].isFold = true
        shareTableView.reloadData()
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
        cell.indexPathRow = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return notes[indexPath.row].cellHeight
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt -- \(indexPath.row)")
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

