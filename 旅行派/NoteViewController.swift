//
//  NoteViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/25.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    fileprivate lazy var shareNavigationViewController = UIStoryboard(name: "ShareViewController", bundle: nil).instantiateInitialViewController() as! UINavigationController
    fileprivate var shareVc: ShareViewController?
    @IBOutlet weak var tableView: UITableView!
    var destination: Destination?{
        didSet{
            oldDestination = oldValue
        }
    }
    var oldDestination: Destination?
    var initial: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if oldDestination == nil || initial || (destination!.name != oldDestination!.name){
            getNote(id: destination!.district_id)
            shareVc?.shareTableView.contentOffset.y = 0
        }
    }
}

extension NoteViewController{
    
    fileprivate func setUp(){
        shareVc = shareNavigationViewController.childViewControllers[0] as? ShareViewController
        addChildViewController(shareVc!)
        shareVc!.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.addSubview(shareVc!.view)
    }
    
    fileprivate func getNote(id: Int){
        NetWorkTool.sharedInstance.getTravelNotes(district_id: id) { (error, result) in
            if error != nil{print(error); return}
            var notes: [TravelNote] = [TravelNote]()
            if let result = result{
                for dict in result{
                    let note = TravelNote(dict: dict)
                    notes.append(note)
                }
                self.shareVc?.notes.removeAll()
                self.shareVc?.notes = notes
            }
//            print(notes.count)
            self.shareVc?.shareTableView.reloadData()
            self.initial = false
        }
    }
    
    
}


