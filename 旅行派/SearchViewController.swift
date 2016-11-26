//
//  SearchViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/21.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

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
    fileprivate var citys:[String] = ["北京","上海","厦门","赤道几内亚","吉尔吉吉斯坦","美利坚合众国"]
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
//    fileprivate func searchCell(tableView: UITableView, row: Int) -> UITableViewCell?{
//        var cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? ShowSearchCityCell
//        if cell == nil{
//            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "searchCell")
//            print(searchText)
//            cell?.textLabel?.text = "查找" + showArr[row]
//        }
//        return cell
//    }
//    
//    fileprivate func showCityCell(tableView: UITableView, indexPath: IndexPath) -> ShowSearchCityCell?{
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowSearchCityCell", for: indexPath) as?ShowSearchCityCell
//        cell?.city = citys[indexPath.row]
//        cell?.selectionStyle = .none
//        return cell
//    }
}




