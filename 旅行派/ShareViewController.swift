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
//    fileprivate lazy var profileVC: ProfileViewController = ProfileViewController()
    fileprivate lazy var PhotoBrowserVC: PhotoBrowserViewController = PhotoBrowserViewController()
    fileprivate lazy var photoBrowserAnimator: PhotoBrowserAnimator = PhotoBrowserAnimator()
    var toolBarModels: [ShareToolModel] = [ShareToolModel]()
    var notes: [TravelNote] = [TravelNote]()
    
    //记录展开全文的行号
    fileprivate var row: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        getTravelNotes()
        setUpNotification()
        setUpAnimator()
        setUpNavigationBar()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension ShareViewController{
    
    fileprivate func setUpNavigationBar(){
        let leftBarButton = UIBarButtonItem(image:UIImage(named: "tabbar_profile") , style: .plain, target: self, action: #selector(self.leftButtonClick))
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    fileprivate func setUpAnimator(){
        PhotoBrowserVC.transitioningDelegate = photoBrowserAnimator
        modalPresentationStyle = .custom
    }
    
    fileprivate func setUpTableView(){
        shareTableView.delegate = self
        shareTableView.dataSource = self
        shareTableView.separatorStyle = .none
        shareTableView.estimatedRowHeight = 500
    }
    
    fileprivate func setUpNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadCellHeight(note:)), name: NSNotification.Name(rawValue: "unfoldNote"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setAnimatorDelegate(note:)), name: NSNotification.Name(rawValue: "selectedImageNote"), object: nil)
    }
    
    @objc private func leftButtonClick(){
        present(ProfileViewController.shared, animated: true, completion: nil)
    }
    
    @objc private func reloadCellHeight(note: Notification){
        row = note.userInfo!["row"] as! Int
        notes[row].cellHeight = note.userInfo!["cellHeight"] as! CGFloat
        notes[row].labelHeight = note.userInfo!["LabelHeight"] as! CGFloat
        notes[row].isFold = true
        shareTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
    }
    
    @objc private func setAnimatorDelegate(note: Notification){
        let cell = note.userInfo!["cell"] as! ShareCell
        photoBrowserAnimator.presentedDelegate = cell
        photoBrowserAnimator.dismissDelegate = PhotoBrowserVC
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
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return notes[indexPath.row].cellHeight
    }
    
}

//MARK:监听照片的点击
extension ShareViewController: ShareCellImageDelegate{
    func mainImageClick(row: Int) {
//        print("选中了第\(row)的照片")
        PhotoBrowserVC.contents = notes[row]._contents
        PhotoBrowserVC.selectedIndex = IndexPath(item: 0, section: 0)
        photoBrowserAnimator.isMain = true
        present(PhotoBrowserVC, animated: true) {}
    }
    
    func picImageClick(row: Int, item: Int) {
//        print("选中了\(row)的第\(item)张照片")
        PhotoBrowserVC.contents = notes[row]._contents
        PhotoBrowserVC.selectedIndex = IndexPath(item: item + 1, section: 0)
        photoBrowserAnimator.item = item
        photoBrowserAnimator.isMain = false
        present(PhotoBrowserVC, animated: true) {}
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

