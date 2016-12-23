//
//  SearchViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/21.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import SVProgressHUD
class SearchViewController: UIViewController {

    static let shared: SearchViewController = SearchViewController()
    fileprivate var searchText: String = ""{
        didSet{
            searchLabel.text = "搜索\(searchText)"
        }
    }
    fileprivate var isSearching: Bool = false{
        didSet{
            if !isSearching{
                searchLabel.text = "热门搜索"
            }else{
                searchLabel.text = "搜索"
            }
            hotTableView.reloadData()
        }
    }
    fileprivate var showArr: [String] = ["游记","攻略"]
    fileprivate var citys:[String] = ["北京","上海","厦门","旧金山","浙江","台湾"]
    fileprivate lazy var detailVc: DetailViewController = DetailViewController()
    fileprivate lazy var animator: SearchAnimator = SearchAnimator()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var hotTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpAnimator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
    @IBAction func closeButtonClick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
}

extension SearchViewController: UISearchBarDelegate, UITableViewDataSource{
    fileprivate func setUpAnimator(){
        modalPresentationStyle = .custom
        transitioningDelegate = animator
    }
    
    fileprivate func setUp(){
        view.frame = UIScreen.main.bounds
        searchBar.delegate = self
        hotTableView.dataSource = self
        hotTableView.delegate = self
        hotTableView.register(UINib(nibName: "ShowSearchCityCell", bundle: nil), forCellReuseIdentifier: "ShowSearchCityCell")
        hotTableView.separatorStyle = .none
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    //dataSource
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if tableView == searchDisplay{
//            return 1
//        }
//    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(text: searchBar.text)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isSearching ? showArr.count : citys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowSearchCityCell", for: indexPath) as!ShowSearchCityCell
        let text = isSearching ? showArr[indexPath.row] : citys[indexPath.row]
        cell.cellText = text
        cell.selectionStyle = .none
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isSearching{
            searchBar.becomeFirstResponder()
            searchBar.text = citys[indexPath.row]
            searchText = citys[indexPath.row]
        }else{
            
        }
    }
}

extension SearchViewController{
    fileprivate func search(text: String?){
        guard let text = text else {
            SVProgressHUD.showError(withStatus: "搜索的内容不能为空")
            SVProgressHUD.dismiss(withDelay: 0.5)
            return
        }
//        NSCharacterSet whitespaceAndNewlineCharacterSet
        if (text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).lengthOfBytes(using: .utf8) == 0){
            SVProgressHUD.showError(withStatus: "搜索的内容不能为空")
            SVProgressHUD.dismiss(withDelay: 0.5)
            return
        }
        SVProgressHUD.show()
        NetWorkTool.sharedInstance.searchDestination(text: text) { (error, destination) in
            if error == nil {
                guard destination != nil else{
                    SVProgressHUD.showInfo(withStatus: "未找到\"\(text)\"的相关内容")
//                    SVProgressHUD.dismiss(withDelay: 0.7)
                    return
                }
                print(destination?.name)
                self.detailVc.destination = destination
                self.detailVc.isPresented = true
                let nav = UINavigationController(rootViewController: self.detailVc)
                self.present(nav, animated: true, completion: { SVProgressHUD.dismiss()})
            }else{
                SVProgressHUD.showInfo(withStatus: "未找到\(text)的相关内容")
//                SVProgressHUD.dismiss(withDelay: 0.7)
            }
        }
    }
    
    
    
    
    
}




